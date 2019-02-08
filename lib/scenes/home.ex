defmodule DisplayOMatic.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  # import Scenic.Primitives
  import Scenic.Components

  @graph Graph.build(font: :roboto, theme: :dark)
         |> button("Discover Devices",
           id: :discover_button,
           button_font_size: 20,
           theme: :primary,
           width: 300,
           height: 50,
           t: {300, 0}
         )

  def init(_, _opts) do
    push_graph(@graph)
    {:ok, @graph}
  end

  def filter_event({:click, :discover_button} = event, _, graph) do
    {:ok, ref} = :dnssd.browse("_raop._tcp")
    Process.sleep(1)
    {:ok, results} = :dnssd.results(ref)
    :ok = :dnssd.stop(ref)

    map =
      Enum.map(results, fn result ->
        result
        |> elem(0)
        |> String.split("@")
        |> List.last()
      end)

    elems = length(map)
    write_to_graph(graph, map, elems)

    {:continue, event, graph}
  end

  # def filter_event({:click, "Device:" <> name} = event, _, graph) do

  # end

  defp write_to_graph(graph, [], _), do: graph

  defp write_to_graph(graph, [device | devices], elems) do
    offset = elems - length(devices)

    case offset do
      1 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {200, 200}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      2 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {200, 200 + 50}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      3 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {200, 200 + 100}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      4 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {200, 200 + 150}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      5 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {200, 200 + 200}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      6 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {300, 200 + 50}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      7 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {300, 200 + 100}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      8 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {300, 200 + 150}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      9 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {300, 200 + 200}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      10 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {300, 200 + 250}
        )
        |> push_graph
        |> write_to_graph(devices, elems)

      11 ->
        graph
        |> button(device,
          id: "Device:" <> device,
          width: 100,
          height: 30,
          theme: :secondary,
          t: {100, 200 + 50}
        )
        |> push_graph
        |> write_to_graph(devices, elems)
    end
  end
end
