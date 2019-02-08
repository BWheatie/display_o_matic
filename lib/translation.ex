defmodule Scenic.Translation do
  @viewport :display_o_matic
            |> Application.get_env(:viewport)
            |> Map.get(:size)
  @viewportx elem(@viewport, 0)
  @viewporty elem(@viewport, 1)

  def padding(pix) do
    x = padding_bottom(pix) - padding_top(pix)
    y = padding_right(pix) - padding_left(pix)

    {x, y}
  end

  def padding_top(pix) do
    pix
  end

  def padding_bottom(pix) do
    @viewportx - pix
  end

  def padding_left(pix) do
    pix
  end

  def padding_right(pix) do
    @viewporty - pix
  end
end
