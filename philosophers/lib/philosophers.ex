defmodule Philosopher do
  @timeout 1000
  @eat 200
  @sleep 400

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def eat(t) do
    :timer.sleep(t)
  end

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> init(hunger, right, left, name, ctrl)end)
  end


  def init(hunger, right, left, name, ctrl) do
    dreaming(hunger, right, left, name, ctrl)
  end


  def dreaming(0, _, _, name, ctrl) do
    send(ctrl, :done)
    IO.puts("#{name} is done")
  end




  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming")
    sleep(@sleep)
    waiting(hunger, right, left, name, ctrl)
  end




  def waiting(hunger, right, left, name, ctrl) do

    case Chopstick.request(right, left, @timeout) do
      :ok -> 
        IO.puts("#{name} has received chopsticks")
        eating(hunger, right, left, name, ctrl)
      :no ->
        IO.puts("#{name} gave up")
        dreaming(hunger, right, left, name, ctrl)
    end
  end




  def eating(hunger, right, left, name ,ctrl) do

    IO.puts("#{name} is eating")
    eat(@eat)
    
    case Chopstick.return(right) do
      :ok -> 
        IO.puts("#{name} has returned the right chopstick")
    end

    
    case Chopstick.return(left) do
      :ok -> 
        IO.puts("#{name} has returned the left chopstick")
        dreaming(hunger - 1, right, left, name, ctrl)
    end
  end




  
end
