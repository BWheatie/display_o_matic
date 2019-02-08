defmodule Scenic.Translation do
  @viewport :display_o_matic
            |> Application.get_env(:viewport)
            |> Map.get(:size)
  # @viewportx elem(@viewport, 0)
  # @viewporty elem(@viewport, 1)

  def padding(pix, points \\ @viewport) do
    case points do
      @viewport ->
        x = padding_bottom(pix, elem(points, 0)) - padding_top(pix, 0)
        y = padding_right(pix, elem(points, 1)) - padding_left(pix, 0)

        {x, y}

      points ->
        x = padding_bottom(pix, elem(points, 0)) - padding_top(pix, elem(points, 0))
        y = padding_right(pix, elem(points, 1)) - padding_left(pix, elem(points, 1))

        {x, y}
    end
  end

  def padding_top(pix, point) when point == 0, do: pix
  def padding_top(pix, point), do: point + pix

  def padding_bottom(pix, point) when point == 0, do: pix
  def padding_bottom(pix, point), do: point - pix

  def padding_left(pix, point) when point == 0, do: pix
  def padding_left(pix, point), do: point + pix

  def padding_right(pix, point) when point == 0, do: pix
  def padding_right(pix, point), do: point - pix
end
