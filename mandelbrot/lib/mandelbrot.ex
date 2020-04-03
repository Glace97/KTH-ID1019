defmodule OBrot do

  def mandelbrot(c, m) do
    z0 = Cmplx.new(0,0)
    i = 0
    test(i, z0, c, m)
  end

  def test(m, _, _, m) do 0 end
  def test(i, z, c, m) do
    abs = Cmplx.abs(z)

    if abs <= 2 do
      zn = Cmplx.add(Cmplx.sqr(z), c)
      test(i + 1, zn, c, m)
    else
      i
    end
  end
end

defmodule Mandel do
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [])
  end
  
  def rows(_, 0, _, _, list) do
    list
  end

  def rows(width, height, trans, depth, list) do
    row = get_row(width, height, trans, depth, [])
    list = [row | list]
    rows(width, height - 1, trans, depth, list)
  end

  defp get_row(0, _, _, _, list) do
    list
  end

  defp get_row(width, height, trans, depth, list) do
    c = trans.(width, height)
    dep = Brot.mandelbrot(c, depth)
    out = Color.convert(dep, depth)
    list = [out | list]
    get_row(width - 1, height, trans, depth, list)
  end
end
