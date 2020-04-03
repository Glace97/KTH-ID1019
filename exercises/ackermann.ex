defmodule Ackermann do
    def acker(m, n) do
        case {m, n} do
            {0, n} -> n + 1
            {m, 0} when m > 0 -> acker(m - 1, 1) 
            _ -> acker(m - 1, acker(m, n - 1))
        end
    end
enD
