defmodule TailwindLiveComponents.Label do
  use Phoenix.Component

  @doc """
  Renders the label field

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `error` - Optional error message to display
    * `input_id` - Optional value to reference the id of the field input
    * `label_id` - Optional value to use as the DOM id of the label
    * `theme` - Optional theme to use for Tailwind classes
  """
  def label(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)

    assigns =
      assigns
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:label_id, fn -> input_id <> "-label" end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div id={@label_id} class="flex items-baseline space-x-2 pl-1">
      <%= if @label do %>
        <label for={@input_id} id={@label_id} class={"block text-md font-medium #{@theme.text_color} mb-0.5"}>
          <%= @label %>
        </label>
      <% end %>

      <%= if @error do %>
        <span class={"#{@theme.error_text_color} text-sm"} phx-feedback-for={@input_id}>
          <%= @error %>
        </span>
      <% end %>
    </div>
    """
  end
end
