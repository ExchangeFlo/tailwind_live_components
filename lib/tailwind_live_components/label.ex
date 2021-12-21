defmodule TailwindLiveComponents.Label do
  use Phoenix.Component

  @doc """
  Renders the label field

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `error` - Optional error message to display
    * `input_id - Optional value to reference the id of the field input
    * `label_id` - Optional value to use as the DOM id of the label
  """
  def label(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)

    assigns =
      assigns
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:label_id, fn -> input_id <> "-label" end)
      |> assign_new(:error, fn -> nil end)

    ~H"""
    <div id={@label_id} class="flex items-baseline space-x-2">
      <%= if @label do %>
        <%= Phoenix.HTML.Form.label(@form, @field, @label, class: "block text-md font-medium text-gray-700 mb-0.5") %>
      <% end %>

      <%= if @error do %>
        <span class="text-red-500 text-sm" phx-feedback-for={@input_id}>
          <%= @error %>
        </span>
      <% end %>
    </div>
    """
  end
end
