defmodule Chopstick do


    def request(right, left, timeout) do
        send(right, {:request, self()})
        send(left, {:request, self()})
        receive do
            :granted ->
                receive do
                    :granted -> :ok
                end
        after timeout ->
            send(right, {:return, self()})
            send(left, {:return, self()})
            :no
        end
    end

    def return(stick) do
        send(stick, {:return, self()})
        receive do
            :returned -> :ok
        end
    end

    def quit(stick) do
        send(stick, :quit)
    end

    
    def start do 
        spawn_link(fn -> available()end)
    end

    def available() do
        receive do
            {:request, from} -> 
                send(from, :granted)
                gone(from)
            :quit -> :ok
        end
    end

    def gone(from) do
        receive do
            {:return, ^from} -> 
                send(from, :returned)
                available()
            :quit -> :ok
        end
    end


end