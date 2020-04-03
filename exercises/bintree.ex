defmodule Bintree do

    def member(_, :nil) do :no end
    def member(e, {:leaf, e}) do :yes end
    def member(_, {:leaf, _}) do :no end

    def member(e, {:node, e, _, _}) do :yes end
    
    def member(e, {:node, v, left, _}) when e < v do
        member(e, left)
    end

    def member(e, {:node, _, _, right})  do
       member(e, right)
    end




    def insert(e, :nil)  do  {:leaf, e}  end
    def insert(e, {:leaf, v}) when e < v  do {:node, v, insert(e, :nil), :nil} end
    def insert(e, {:leaf, v}) do  {:node, v, :nil, insert(e, :nil)}   end
    def insert(e, {:node, v, left, right }) when e < v do
        {:node, v, insert(e, left), right }
    end

    def insert(e, {:node, v, left, right })  do
        {:node, v, left, insert(e, right)}
    end


    def delete(e, {:leaf, e}) do  :nil  end
    def delete(e, {:node, e, :nil, right}) do  right  end
    def delete(e, {:node, e, left, :nil}) do  left  end
    def delete(e, {:node, e, left, right}) do
        {:node, reightmost(left), delete(reightmost(left), left), right}
    end
    def delete(e, {:node, v, left, right}) when e < v do
        {:node, v,  delete(e, left),  right}
    end
    def delete(e, {:node, v, left, right})  do
        {:node, v,  left,  delete(e, right)}
    end

    def reightmost({:leaf, e}) do e end
    def reightmost({:node, _, _ , right}) do  reightmost(right)  end





end
