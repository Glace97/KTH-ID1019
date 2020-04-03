defmodule Eager do
    def eval_expr({:atm, id}, _, _) do {:ok, id} end
    
    def eval_expr({:var, id}, env, _) do
        case Env.lookup(id, env) do
            nil -> :error
            {_, str} -> {:ok, str}
        end
    end

    def eval_expr({:cons, head, tail}, env, prg) do
        case eval_expr(head, env, prg) do
            :error -> :error
            {:ok, str} ->
                case eval_expr(tail, env, prg) do
                    :error -> :error
                    {:ok, ts} -> {:ok, {str, ts}}
                end
        end
    end

    def eval_match(:ignore, _, env) do
        {:ok, env}
    end

    def eval_match({:atm, id}, id, env) do
        {:ok, env}
    end
    
    def eval_match({:var, id}, str, env) do
        case Env.lookup(id, env) do
            nil -> {:ok, Env.add(id, str, env)}
            {_, ^str} -> {:ok, env}
            {_, _} -> :fail
        end
    end

    def eval_match({:cons, hp, tp}, {str,ts}, env) do
        case eval_match(hp, str, env) do 
            :fail -> :fail
            {_, newenv} -> eval_match(tp, ts, newenv)
        end
    end

    def eval_match(_, _, _) do
        :fail
    end
    
    def extract_vars(pattern) do
        case pattern do
            {:var, id} -> [id]
            {:cons, {:var, id1}, {:var , id2}} -> [id1, id2]
            {:cons, {:var, id}, _} -> [id]
            {:cons, _, {:var, id}} -> [id] 
            _ -> []
        end
    end


    def eval_scope(exp, env) do
        Env.remove(extract_vars(exp), env)
    end

    def eval_seq([exp], env, prg) do
        eval_expr(exp, env, prg)
    end

    def eval_seq([{:match, one, two} | rest ], env, prg) do
        case eval_expr(two,env, prg) do
            :fail ->
                :fail
            {_, data} -> 
                nenv = eval_scope(one, env)
                case eval_match(one, data, nenv) do
                    :fail ->
                        :error
                    {:ok, env} ->
                        eval_seq(rest, env, prg)
                end
        end
    end

    def eval(seq, prg) do
        case eval_seq(seq, [], prg) do
            {:ok, str} -> {:ok, str}
            :error -> :error
        end
    end

    def seq() do
        [{:match, {:var, :x}, {:atm,:a}},
        {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
        {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
        {:var, :z}]
    end

    def eval_expr({:case, expr, cls}, env, prg) do
        case eval_expr(expr,env, prg) do
            :error ->
                :error
            {_, data} ->
                eval_cls(cls, data, env, prg)
        end
    end

    def eval_cls([], _, _, _) do
        :error
    end

    def eval_cls([{:clause, ptr, seq} | cls], data, env, prg) do
       match = eval_match(ptr, data, env)
       case match do 
            :fail ->
                eval_cls(cls, data, env, prg)
            {:ok, env} ->
                eval_seq(seq, env, prg)
       end
    end

    def seq2() do
        [{:match, {:var, :x}, {:atm, :a}},
        {:case, {:var, :x},
            [{:clause, {:atm, :b}, [{:atm, :ops}]},
            {:clause, {:atm, :a}, [{:atm, :yes}]}
            ]}
        ]
    end

    def eval_expr({:lambda, par, free, seq}, env, _) do
        case Env.closure(free, env) do
            :error ->
                :error
            closure ->
                {:ok, {:closure, par, seq, closure}}
        end
    end

    def eval_expr({:apply, expr, args}, env, prg) do
        case eval_expr(expr, env, prg) do
            :error ->
                :error
            {:ok, {:closure, par, seq, closure}} ->
                case eval_args(args, closure, prg) do
                    :error ->
                        :foo
                    strs ->
                        env = Env.args(par, strs, closure)
                        eval_seq(seq,env, prg)
                end
        end
    end

    def eval_args([], _, _) do [] end

    def eval_args([h | t], env, prg) do
        case eval_expr(h, env, prg) do
        :error -> 
            :error
        {_, data} ->
            case eval_args(t, env, prg) do
                :error ->
                    :error
                strs ->
                    [data | strs]
            end
        end
    end



    def seq3 do
        [{:match, {:var, :x}, {:atm, :a}},
        {:match, {:var, :z}, {:atm, :c}},
        {:match, {:var, :f},
        {:lambda, [:y], [:x, :z], [{:cons, {:var, :x}, {:cons, {:var, :y}, {:var, :z}}}]}},
        {:apply, {:var, :f}, [{:atm, :b}]}
        ]
    end

    def eval_expr({:call, id, args}, env, prg) when is_atom(id) do
        case List.keyfind(prg, id, 0) do
            nil ->
                :error
            {_, par, seq} ->
                case eval_args(args, env, prg) do
                :error ->
                    :error
                strs ->
                    env = Env.args(par, strs, [])
                    eval_seq(seq, env, prg)
                end
        end
    end

    defp prgm do
        [{:append, [:x, :y],
            [{:case, {:var, :x},
                [{:clause, {:atm, []}, [{:var, :y}]},
                 {:clause, {:cons, {:var, :hd}, {:var, :tl}},
                    [{:cons,
                        {:var, :hd},
                        {:call, :append, [{:var, :tl}, {:var, :y}]}}]
                 }]
            }]
        }]
    end

    defp seqlast do
        [{:match, {:var, :x},
        {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
        {:match, {:var, :y},
        {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
        {:call, :append, [{:var, :x}, {:var, :y}]}
        ]
    end

    def test4 do
        eval_seq(seqlast(), [], prgm())
    end

    def test3 do
        eval_seq(seq3(), [], [])
    end

    def test2 do
        eval_seq(seq2(), [], [])
    end
    def test1 do
        eval_seq(seq(), [], [])
    end

end