defmodule LS do
    def tak(n) do
        case n do
            [] -> :no
            [head | _] -> {:ok , head}
        end
    end

    def drp(n)do
        case n do
            [] -> :no
            [_ | tail] -> {:ok , tail}
        end
    end

    def len(l) do
        case l do
            [] -> 0
            [_ | tail] -> 1 + len(tail)
        end
    end

    def sum(l) do
        case l do
            [] -> 0
            [head | tail] -> head + sum(tail)
        end
    end

    def duplicate(l) do
        case l do
            [] -> []
            [head | tail] -> [2 * head | duplicate(tail)]
        end
    end

    def add2(x, l) do
        case l do
            [] -> [x | l]
            [h | _] when x == h  -> l
            [h | t] -> [h | add2(x,t)]
        end
    end

    def add(x, l) do
        [x | l]
    end

    def remove(x , l) do
        case l do
            [] -> []
            [^x | tail] -> remove(x, tail)
            [head | tail] -> add(head,remove(x, tail))
        end
    end

    def unique(l) do
        case l do
            [] -> []
            [head | tail] -> add(head, unique(remove(head, tail)))
        end
    end

    def append(x, l) do
        x ++ l
    end

    def append2([], y) do y end

    def append2([h|t], y) do
        [h | append2(t,y)]
    end

    def nreverse([]) do [] end

    def nreverse([h | t]) do
        r = nreverse(t)
        append(r,[h])
    end
    
    def reverse(l) do
        reverse(l,[])
    end

    def reverse([], r) do r end
    def reverse([h | t], r) do
        reverse(t, [h | r])
    end



    def bench() do
        ls = [16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
        n = 100
        # bench is a closure: a function with an environment.
        bench = fn(l) ->
            seq = Enum.to_list(1..l)
            tn = time(n, fn -> nreverse(seq) end)
            tr = time(n, fn -> reverse(seq) end)
            :io.format("length: ~10w  nrev: ~8w us    rev: ~8w us~n", [l, tn, tr])
    end

    # We use the library function Enum.each that will call
    # bench(l) for each element l in ls
    Enum.each(ls, bench)
    end

    # Time the execution time of the a function.
    def time(n, fun) do
        start = System.monotonic_time(:milliseconds)
        loop(n, fun)
        stop = System.monotonic_time(:milliseconds)
        stop - start
    end

    # Apply the function n times.
    def loop(n, fun) do
        if n == 0 do
        :ok
    else
        fun.()
        loop(n - 1, fun)
    end
end


end