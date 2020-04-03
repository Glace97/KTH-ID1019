defmodule Env do
    def new do
        []
    end

    def add(id, str, env) do
        case lookup(id, env) do
            nil -> [{id, str} | env]
            _ -> update(id, str,env)
        end
    end

    def update(id, str, [{h, val} | t]) do
        case id do
            ^h -> [{h, str} | t]
            _ -> [{h,val} | update(id, str, t)]
        end
    end


    def lookup(_, []) do nil end

    def lookup(id ,[{h, str} | t]) do
        case h do
            ^id -> {h,str}
            _ -> lookup(id, t)
        end
    end

    def remove([], env) do env end

    def remove([h | t], env) do
        newenv = remove_id(h, env)
        remove(t, newenv)
    end


    def remove_id(id, [{atom, val} | t]) do
        case id do
            ^atom -> t
            _ -> [{atom, val} | remove_id(id, t)]
        end
    end
    
    def remove_id(_, []) do [] end


    def closure([], _) do [] end

    def closure([id | t], env) do
        case lookup(id, env) do
            {h, str} -> [{h, str} | closure(t, env)]
            nil -> :error
        end
    end


    def args([], [], closure) do closure end

    def args([par | restp], data , closure) do
        case data do
            [val | t] -> [{par, val} | args(restp, t, closure)]
            val -> [{par, val} | closure]
        end
    end
end
