defmodule AsicSentryWeb.AsicMinerLive.FormComponent do
  use AsicSentryWeb, :live_component

  alias AsicSentry.AsicMiners

  @impl true
  def update(%{asic_miner: asic_miner} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(AsicMiners.change_asic_miner(asic_miner))
     end)}
  end

  @impl true
  def handle_event("validate", %{"asic_miner" => asic_miner_params}, socket) do
    changeset = AsicMiners.change_asic_miner(socket.assigns.asic_miner, asic_miner_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"asic_miner" => asic_miner_params}, socket) do
    save_asic_miner(socket, socket.assigns.action, asic_miner_params)
  end

  defp save_asic_miner(socket, :edit, asic_miner_params) do
    case AsicMiners.update_asic_miner(socket.assigns.asic_miner, asic_miner_params) do
      {:ok, asic_miner} ->
        notify_parent({:saved, asic_miner})

        {:noreply,
         socket
         |> put_flash(:info, "ASIC miner updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_asic_miner(socket, :new, asic_miner_params) do
    case AsicMiners.create_asic_miner(asic_miner_params) do
      {:ok, asic_miner} ->
        notify_parent({:saved, asic_miner})
        {:noreply,
         socket
         |> put_flash(:info, "ASIC miner created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
