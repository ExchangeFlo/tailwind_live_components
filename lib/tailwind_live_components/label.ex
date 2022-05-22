defmodule TailwindLiveComponents.Label do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @doc """
  Renders the label field

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `required` - Optional flag indicating that field is required
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
      |> assign_new(:error_id, fn -> input_id <> "-error" end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div class="flex items-baseline space-x-2 pl-1">
      <%= if @label do %>
        <label for={@input_id} id={@label_id} class={"block text-md #{if @required, do: "font-bold", else: "font-medium"} #{@theme.text_color} mb-0.5"}>
          <%= @label %>
        </label>
      <% end %>

      <%= if @error do %>
        <span
          id={@error_id}
          class={"flex-1 #{@theme.error_text_color} text-sm"}
          phx-feedback-for={@input_id}
          phx-hook="tlcLabelError"
          data-show={show_error()}
        >
          <%= @error %>
        </span>
      <% end %>
    </div>
    """
  end

  defp show_error(js \\ %JS{}) do
    JS.show(js,
      time: 300,
      display: "inline-block",
      transition: {"ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95", "opacity-100 translate-y-0 sm:scale-100"}
    )
  end
end
