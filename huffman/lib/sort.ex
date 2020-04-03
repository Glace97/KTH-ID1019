defmodule ST do
    def insert(element, list) do
        {_, _, v, _, _, _} = element
        case list do
            [] -> [element]
            [{_, _, b, _ , _, _} | _] when b >= v -> [element | list] 
            [h | t] -> [h | insert(element, t)]
        end
    end





    #Merge sort
    def msort(l) do
        case l do
            [] -> []
            [h | []] -> [h]
            _ -> 
                {f , s} = msplit(l, [], [])
                merge(msort(f), msort(s))
        end
    end

    def merge(f, []) do f end
    def merge([], s) do s end
    def merge([h1 | t1], [h2 | t2]) do
        {_,_,v1,_,_} = h1
        {_,_,v2,_,_} = h2
        if v1 <= v2 do
            [h1 | merge([h2 | t2], t1)]
        else
            [h2 | merge([h1 | t1], t2)]
        end
    end
    

    def msplit(l, f ,s) do
        case l do
            [] -> {f, s}
            [h | []]  -> {[h | f], s}
            [h1|[h2 | t]]-> msplit(t, [h1 | f] , [h2 | s])
        end
    end




        #Merge sort
        def msort2(l) do
            case l do
                [] -> []
                [h | []] -> [h]
                _ -> 
                    {f , s} = msplit(l, [], [])
                    merge2(msort2(f), msort2(s))
            end
        end
    
        def merge2(f, []) do f end
        def merge2([], s) do s end
        def merge2([h1 | t1], [h2 | t2]) do
            {_, v1, _} = h1
            {_,v2, _} = h2
            if v1 <= v2 do
                [h1 | merge2([h2 | t2], t1)]
            else
                [h2 | merge2([h1 | t1], t2)]
            end
        end
end