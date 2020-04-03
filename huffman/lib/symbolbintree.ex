defmodule Symbolbintree do

    def lookup(_, :nil) do :no end

    def lookup(k, {:node, k, value, _, _}) do {:ok, value} end

    def lookup(k, {:node, key, _, left, _}) when k < key do 
        lookup(k, left)
    end
     def lookup(k, {:node, _, _, _, right}) do 
        lookup(k, right)
    end




    def add(k, :nil)  do  {:node, k, 1, :nil, :nil}  end

    def add(k, {:node, k, value,  left, right}) do
        {:node, k, value + 1, left, right}
    end

    def add(k, {:node, key, value,  left, right }) when k < key do
        {:node, key, value, add(k, left), right }
    end

    def add(k, {:node, key, value,  left, right }) do
        {:node, key, value, left, add(k, right)}
    end


    def remove(_, :nil)  do  :nil  end
    def remove(k, {:node, k, _, :nil, right}) do  right  end
    def remove(k, {:node, k, _, left, :nil}) do  left  end
    def remove(k, {:node, k, _, left, right}) do
        {newk, newv} = reightmost(left)
        {:node, newk,  newv, remove(newk, left), right}
    end
    def remove(k, {:node, key, value, left, right}) when k < key do
        {:node, key, value,  remove(k, left),  right}
    end
    def remove(k, {:node, key, value, left, right})  do
        {:node, key, value,  left,  remove(k, right)}
    end

    def reightmost({:node, key, value, _, :nil}) do {key, value} end
    def reightmost({:node, _,  _, _, right}) do  reightmost(right)  end

    def leftmost({:node, key, value, :nil, _}) do {key, value} end
    def leftmost({:node, _,  _, left, _}) do  leftmost(left)  end



    
end
