defmodule ST do
    def insert(element, list) do
        case list do
            [] -> [element]
            [h | _] when h >= element -> [element | list] 
            [h | t] -> [h | insert(element, t)]
        end
    end



    def isort(l) do
        isort([] , l)
    end

    def isort(x, l) do
        case l do 
         [] -> []
         [h | t] -> insert(h,isort(x, t))
        end
    end

    #tail recursive isort
    def tsort(l) do tsort(l, []) end

    def tsort([] , sofar) do sofar end

    def tsort(l, sofar) do
        case l do
            [] -> []
            [h | t] -> tsort(t, insert(h, sofar))
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
        if h1 <= h2 do
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




    def qsort([]) do [] end
    def qsort([p | l]) do 
        {f, s} = qsplit(p, l, [], [])
        small = qsort(f)
        large = qsort(s)
        append(small, [p | large])
    end


    def qsplit(_, [], small, large) do {small, large} end
    def qsplit(p, [h | t], small, large) do
        if h <= p do
            qsplit(p, t, [h | small], large)
        else
            qsplit(p, t, small , [h | large])
        end
    end


    def append([], s) do s end

    def append([h | t], s) do
        [h | append(t, s)]
    end
end