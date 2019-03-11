defmodule DisplayOMatic.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  import Scenic.Components

  @dns_device_type "_raop._tcp"
  @graph Graph.build(font: :roboto)
         |> button("Discover Devices",
           id: :discover_button,
           button_font_size: 20,
           theme: :primary,
           width: 300,
           height: 50,
           t: {270, 0}
         )

  def init(_, _opts) do
    push_graph(@graph)
    {:ok, @graph}
  end

  def filter_event({:click, :discover_button} = event, _, graph) do
    results = dns_discovery(@dns_device_type)

    devices =
      Enum.map(results, fn result ->
        result
        |> elem(0)
        |> String.trim("\n")
        |> String.split("@")
        |> List.last()
      end)

    graph
    |> Graph.modify(:discover_button, &update_opts(&1, hidden: true))
    |> write_to_graph(devices)
    |> push_graph

    {:continue, event, graph}
  end

  defp write_to_graph(graph, devices) do
    graph =
      graph
      |> rect({500, 200}, id: :button_container, translate: {200, 100})
      |> group(
        fn g ->
          Enum.reduce(devices, g, fn device, g ->
            g
            |> button(device,
              id: "Device:" <> device,
              hidden: true
            )
          end)
        end,
        width: 100,
        height: 30,
        theme: :secondary,
        id: :button_group
      )

    container =
      graph
      |> Scenic.Graph.get(:button_container)
      |> List.first()
      |> IO.inspect()

    group =
      graph
      |> Scenic.Graph.get(:button_group)
      |> List.first()
      |> Map.get(:data)

    list_of_ids = Map.get(group, :data)
    component = Map.get(group, :styles)

    translations =
      Scenic.Translation.Container.put_in_container(
        %{data: Map.get(container, :data), styles: Map.get(container, :styles)},
        {component, list_of_ids},
        {nil, nil}
      )

    Map.each(translations, fn {id, translate} ->
      graph
      |> Graph.modify(id, )
    end)

  end

  defp dns_discovery(device_type) do
    {:ok, ref} = :dnssd.browse(device_type)
    Process.sleep(1)
    {:ok, results} = :dnssd.results(ref)
    :ok = :dnssd.stop(ref)
    results
  end
end

# Graph.modify(container, hd, fn id ->
#                         update_opts(hd,
#                           translate:
#                         )
#                       end)
