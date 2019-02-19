defmodule Scenic.Translations.Container do

  @viewport :display_o_matic
            |> Application.get_env(:viewport)
            |> Map.get(:size)
  # Takes a list of components/primitives, size of the container, options: starting x, y
  def build_container(graph, [], _starting_location), do: graph
  def build_container(
        %{
          module: Scenic.Primitive.Rectangle,
          data: {container_sizex, container_sizey} = container,
          transforms: %{translate: {container_locationx, container_locationy}}
        } = graph,
        [%{styles: %{height: component_height, width: component_width}} = hd | rest],
        starting_location \\ nil
      ) do
    case container <= @viewport do
      #check if container fits in viewport
      true ->
        container_edges =
          {container_locationx + container_sizex, container_locationy + container_sizey}

        case starting_location do
          #First elem to go in container
          nil ->
            Map.put(hd, :transform, {elem(starting_location, 0), elem(starting_location, 1)})
            build_container(container, rest, Map.get(hd, :transform))
          #subsequent elems to go in  container
          {startingx, startingy} ->
            case still_in_containery?(starting_location, container_edges, {nil, component_width}) do
              #elem fits in y of container
              true ->
                case still_in_containerx?(starting_location, container_edges, {component_height, nil}) do
                  #elem fits in x of container; elem fits in container
                  true ->
                    transform = {startingx, startingy + component_width}
                    Map.put(hd, :transform, transform)

                    build_container(graph, rest, transform))
                  #shouldnt get here?
                  false ->
                    {:error, "Something went wrong"}
                end

              #does not fit in y of container; check if it still fits in x of container
              false ->
                case still_in_containerx?({startingx + component_height, nil}, container_edges, {component_height, nil}) do
                  #fits in x of container; check if it will fit new y in container
                  true ->
                    case still_in_containery?({nil, startingy + component_width}, container_edges, {nil, component_width}) do
                      #fits new row of container
                      true ->
                        transform = {startingx + component_height, startingy}
                        Map.put(hd, :transform, transform)

                        build_container(graph, rest, transform)

                      #shouldnt get here?
                      _ ->
                        {:error, "Something went wrong"}
                    end

                  #container is full
                  false ->
                    {:error, "Container full"}
                end
            end
        end

      false ->
        {:error, "Container does not fit in viewport"}
    end
  end

  def still_in_containery?(
        {_, startingy},
        {_, container_edgey},
        {component_width, _}
      ) do
    startingy + component_width <= container_edgey
  end

  def still_in_containerx?(
        {startingx, _},
        {container_edgex, _},
        {_, component_height}
      ) do
    startingx + component_height <= container_edgex
  end
end
