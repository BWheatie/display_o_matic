defmodule Scenic.Translations.Container do
  @viewport :display_o_matic
            |> Application.get_env(:viewport)
            |> Map.get(:size)
  # Takes a list of components/primitives, size of the container, options: starting x, y
  def build_container([hd | rest] = things, {containerx, containery}, opts \\ []) do
    style = Map.get(hd, :style)
    case container_size <= @viewport do
      true ->
        style.width + 2
      false ->
        :error
    end
  end
end