defmodule Symbolbintree do

    def lookup(_, :nil) do :no end

    def lookup(k, {:node, k, value, _, _}) do {:ok, value} end

    def lookup(k, {:node, key, _, left, _}) when k < key do 
        lookup(k, left)
    end
     def lookup(k, {:node, _, _, _, right}) do 
        lookup(k, right)
    end




    def add(k, v, :nil)  do  {:node, k, v, :nil, :nil}  end

    def add(k, v, {:node, k, _,  left, right}) do
        {:node, k, v, left, right}
    end

    def add(k, v, {:node, key, value,  left, right }) when k < key do
        {:node, key, value, add(k, v, left), right }
    end

    def add(k, v, {:node, key, value,  left, right }) do
        {:node, key, value, left, add(k, v, right)}
    end


    def remove(_, _, :nil)  do  :nil  end
    def remove(k, v, {:node, k, v, :nil, right}) do  right  end
    def remove(k, v, {:node, k, v, left, :nil}) do  left  end
    def remove(k, v, {:node, k, v, left, right}) do
        {newk, newv} = reightmost(left)
        {:node, newk,  newv, remove(newk, newv, left), right}
    end
    def remove(k, v, {:node, key, value, left, right}) when k < key do
        {:node, key, value,  remove(k, v, left),  right}
    end
    def remove(k, v, {:node, key, value, left, right})  do
        {:node, key, value,  left,  remove(k, v, right)}
    end

    def reightmost({:node, key, value, :nil, :nil}) do {key, value} end
    def reightmost({:node, _,  _, _, right}) do  reightmost(right)  end





end
