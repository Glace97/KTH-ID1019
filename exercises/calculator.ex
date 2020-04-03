defmodule Calc do
    def eval({:int, n}) do n end

    def eval({:add, a, b}, bindings) do 
        eval(a, bindings)  +  eval(b, bindings)
    end

    def eval({:sub, a, b}, bindings) do 
        eval(a, bindings)  -  eval(b, bindings)
    end

    def eval({:mul, a, b}, bindings) do 
        eval(a, bindings)  *  eval(b, bindings)
    end

    def eval({:var, name}, bindings) do  lookup(name, bindings) end

    def lookup(var, [{:bind, var, value} | _] ) do value end
    def lookup(var, [_ | rest]) do lookup(var, rest) end 

end