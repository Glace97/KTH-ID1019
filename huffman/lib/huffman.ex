defmodule Huffman do
    def sample() do
        'the quick brown fox jumps over the lazy dog
        this is a sample text that we will use when we build
        up a table we will only handle lower case letters and
        no punctuation symbols the frequency will of course not
        represent english but it is probably not that far off'
    end

    def text() do
        'this is something that we should encode'
    end

    def test(sample) do
        tree = tree(sample)
        encode = encode_table(tree)
        seq = encode(sample, encode)
        decode(seq, tree)
    end

    def tree(sample) do
        output = freq(sample)
        freq = sortfreq(output)
        huffman(freq)
    end


    def encode_table(tree) do 
        {_, done} = encode_table(tree, [], [])
        ST.msort2(done)
    end

    def encode_table({:node, :nil , _, _, left, right}, table, accum) do
        {table, done} = encode_table(left, [0 | table], accum)
        case {table, done} do
            {[_ | _], _} -> [_ | t] = table
                                 {table, done} = encode_table(right, [1 | t] , done)
                                 case {table, done} do
                                    {[_ | t], output} -> {t, output}
                                    {[], done} -> {table, done}
                                 end
            {[], done} -> {table,done}
        end
    end

    def encode_table({:node, c, _, rank ,_, _}, table, accum) do
        {table, [{c, rank, LS.reverse(table)} | accum]}
    end


    def encode([], _) do
        []
    end

    def encode(text, table) do
       {bits, rest}= encode_char(text, table)
       bits ++ encode(rest, table)
    end

    def encode_char(text, table) do
        [{char, _, enc} | rest] = table
        case text do
        [h | t] when h == char -> {enc, t}
        _ -> encode_char(text, rest)
        end
    end

    def decode([], _) do [] end
    def decode(seq, tree) do
        {char, rest} = decode_char(seq, tree)
        [char | decode(rest, tree)]
    end

    def decode_char(seq,{:node, c, _, _, :nil, _}) do
        {c, seq}
    end

    def decode_char(seq,{:node, c, _, _, _, :nil}) do
        {c, seq}
    end

    def decode_char(seq, {:node, _, _, _,left, right}) do
        case seq do
           [0|t] -> decode_char(t, left)
           [1|t] -> decode_char(t, right) 
           [] -> []
        end
    end
    
    def freq(sample) do
        freq(sample, :nil)
    end

    def freq([], freq) do freq end

    def freq([char | rest], freq) do
       freq(rest, Symbolbintree.add(char ,freq))
    end

    def sortfreq(freq) do
        out = sortfreq(freq ,[])
        freqlist = ST.msort(out)
        mark(freqlist)
    end

    def mark(out) do
        leng = Kernel.length(out)
        mark(out, leng)
    end

    def mark([], _) do [] end

    def mark([h | t], leng) do
        {:node, c, v, :nil, :nil} = h
        [{:node, c, v, leng, :nil, nil} | mark(t, leng - 1)]
    end

    def sortfreq(:nil, sorted) do sorted end
    
    def sortfreq({:node, c, v, left, right}, sorted) do
        sortfreq(right, sortfreq(left, [{:node, c, v, :nil, :nil} | sorted]))
    end





    def huffman([h | []]) do h end
    def huffman([h1 | [h2 | t]]) do
        {:node, _, f1, _, _, _} = h1
        {:node, _, f2, _, _, _} = h2
        if f2 >= f1 do
            t = ST.insert({:node, :nil, f1+f2, :nil, h1, h2}, t)
            huffman(t)
        else
            t = ST.insert({:node, :nil, f1+f2, :nil, h2, h1}, t)
            huffman(t)
        end
    end



    def read(file, n) do
        {:ok, file} = File.open(file, [:read])
        binary = IO.read(file, n)
        File.close(file)
        case :unicode.characters_to_list(binary, :utf8) do
        {:incomplete, list, _} -> list;
        list -> list
        end
    end
    
    def writetofile(text) do
        {:ok, file} = File.open("out.txt", [:write])
        IO.write(file, text)
        File.close(file)
    end


    def writeEncoding(encoding) do
        {:ok, file} = File.open("out.txt", [:write])
        writeExtract(encoding, file)
        File.close(file)
    end

    def writeExtract([], _) do end

    def writeExtract([h | t], file)do
        IO.write(file, h)
        writeExtract(t, file)
    end

    def time(sample) do
        startf = System.monotonic_time(:nanosecond)

        start = System.monotonic_time(:nanosecond)
        output = freq(sample)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to count freq")

        start = System.monotonic_time(:nanosecond)
        freq = sortfreq(output)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to count sort freqs")

        start = System.monotonic_time(:nanosecond)
        tree = huffman(freq)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to build tree")

        start = System.monotonic_time(:nanosecond)
        encode = encode_table(tree)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to build encode table")
        
        start = System.monotonic_time(:nanosecond)
        seq = encode(sample, encode)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to encode")
        
        start = System.monotonic_time(:nanosecond)
        decode(seq, tree)
        stop = System.monotonic_time(:nanosecond)
        res = (stop - start)/(:math.pow(10,6))
        IO.puts("#{res}ms to decode")

        stopf = System.monotonic_time(:nanosecond)
        IO.puts((stopf - startf)/(:math.pow(10,6)))
    end
end
