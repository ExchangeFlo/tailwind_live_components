defmodule TailwindLiveComponents.Toggle do
  use Phoenix.Component

  alias TailwindLiveComponents.Label

  @doc """
  Renders the toggle

  ```
  <.toggle form={:basket} field={:fruit} label="Fruit" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `detail` - Optional detail shown below the input
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def toggle(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"
    selected_value = Phoenix.HTML.Form.input_value(assigns.form, assigns.field)

    assigns =
      assigns
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:selected_value, fn -> selected_value end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div
      x-data={"{ on: #{@selected_value == "true"} }"}
      class="flex items-center"
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "on") %>

      <div
        @click="on = !on"
        @keydown.enter.prevent="on = !on"
        @keydown.space.prevent="on = !on"
        class={"#{background(@theme, @selected_value)} relative inline-flex flex-shrink-0 h-8 w-14 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:#{@theme.focus_ring_color}"}
        :class={"{
          '#{@theme.selected_bg_color}': on,
          '#{@theme.light_bg_color}': !(on)
        }"}
        role="switch"
        tabindex="0"
        :aria-checked="on.toString()"
        aria-labelledby={@label_id}
      >
        <span
          aria-hidden="true"
          class={"#{position(@selected_value)} pointer-events-none inline-block h-7 w-7 rounded-full #{@theme.bg_color} shadow transform ring-0 transition ease-in-out duration-200"}
          :class="{
            'translate-x-6': on,
            'translate-x-0': !(on)
          }"
        ></span>
      </div>

      <span class="ml-3 flex flex-col">
        <Label.label
          form={@form}
          field={@field}
          theme={@theme}
          label={@label}
          input_id={@input_id}
          label_id={@label_id}
          error={@error}
        />

        <%= if @detail do %>
          <span class={"#{@theme.light_text_color} text-sm pl-1"}>
            <%= @detail %>
          </span>
        <% end %>
      </span>
    </div>
    """
  end

  defp background(theme, "true"), do: theme.selected_bg_color
  defp background(theme, _), do: theme.light_bg_color

  defp position("true"), do: "translate-x-6"
  defp position(_), do: "translate-x-0"
end
