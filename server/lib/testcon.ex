defmodule TestCon do

    
    @number_requests 100


    def bench(host, port) do
        start = Time.utc_now()
        me = self();
        run(@number_requests, host, port, 0, me)
        finish = Time.utc_now()
        diff = Time.diff(finish, start, :millisecond)
        IO.puts("Benchmark: #{@number_requests} requests in #{diff} ms")
    end


    defp run(0, _, _, @number_requests, _) do :ok end

    defp run(0, _host, _port, counter, _) do
        receive do
            :done -> run(0, :nil, :nil, 1 + counter, :nil)
        end
    end




    defp run(n, host, port, cnt, me) do
        spawn(fn -> contact(host, port, me) end)
        run(n - 1, host, port, cnt, me)
    end

    defp contact(host, port, ctrl) do
        opt = [:list, active: false, reuseaddr: true]
        {:ok, server} = :gen_tcp.connect(host, port, opt)
        :gen_tcp.send(server, HTTP.get("foo"))
        {:ok, _reply} = :gen_tcp.recv(server, 0)
        :gen_tcp.close(server)
        send(ctrl, :done)
    end
    
end