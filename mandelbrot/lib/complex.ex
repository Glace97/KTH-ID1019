defmodule Cmplx do
    
    def new(r, i) do
        {r, i}
    end

    def add({r1,i1},{r2,i2}) do
        {r1 + r2, i1 + i2}
    end

    def sqr({r, i}) do
        {r*r - i*i, 2*r*i}
    end

    def abs({r, i}) do
        :math.sqrt(r*r + i*i)
    end



    def mandelbrot({cr, ci}, m) do
    zr = 0
    zi = 0
    test(0, zr, zi, cr, ci, m)
    end

  defp test(m, _zr, _zi, _cr, _ci, m), do: 0
  defp test(i, zr, zi, cr, ci, m) do
    zr2 = zr * zr
    zi2 = zi * zi
    a2 = zr2 + zi2

    if a2 < 4.0 do
      sr = zr2 - zi2 + cr
      si = 2 * zr * zi + ci
      test(i + 1, sr, si, cr, ci, m)
    else
      i
    end
  end

end