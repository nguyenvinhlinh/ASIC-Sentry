defmodule AsicSentryWeb.ConfigLive.FormComponent do
  use AsicSentryWeb, :live_component

  alias AsicSentry.Configs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage config records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="config-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:key]} type="text" label="Key" />
        <.input field={@form[:value]} type="text" label="Value" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Config</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{config: config} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Configs.change_config(config))
     end)}
  end

  @impl true
  def handle_event("validate", %{"config" => config_params}, socket) do
    changeset = Configs.change_config(socket.assigns.config, config_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"config" => config_params}, socket) do
    save_config(socket, socket.assigns.action, config_params)
  end

  defp save_config(socket, :edit, config_params) do
    case Configs.update_config(socket.assigns.config, config_params) do
      {:ok, config} ->
        notify_parent({:saved, config})

        {:noreply,
         socket
         |> put_flash(:info, "Config updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_config(socket, :new, config_params) do
    case Configs.create_config(config_params) do
      {:ok, config} ->
        notify_parent({:saved, config})

        {:noreply,
         socket
         |> put_flash(:info, "Config created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
