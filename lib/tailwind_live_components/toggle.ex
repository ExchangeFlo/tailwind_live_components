defmodule TailwindLiveComponents.Toggle do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
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
    * `value` - The current value for the input
    * `detail` - Optional detail shown below the input
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def toggle(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    assigns =
      assigns
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:value, fn -> "false" end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div
      id={@input_id <> "-container"}
      phx-hook="tlcToggle"
      class="flex items-center"
    >
      <%= Phoenix.HTML.Form.hidden_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        "data-tlc-ref": "valueInput"
      ) %>

      <div
        class={"#{background(@theme, @value)} relative inline-flex flex-shrink-0 h-8 w-14 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 #{@theme.focus_ring_color}"}
        data-toggle-on={toggle_background_on(@theme)}
        data-toggle-off={toggle_background_off(@theme)}
        role="switch"
        tabindex="0"
        aria-checked={@value}
        aria-labelledby={@label_id}
        tlc-ref="toggleInput"
      >
        <span
          aria-hidden="true"
          class={"#{position(@value)} pointer-events-none inline-block h-7 w-7 rounded-full #{@theme.bg_color} shadow transform ring-0 transition ease-in-out duration-200"}
          data-toggle-on={toggle_position_on()}
          data-toggle-off={toggle_position_off()}
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

  defp toggle_background_on(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.light_bg_color)
    |> JS.add_class(theme.selected_bg_color)
  end

  defp toggle_background_off(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_bg_color)
    |> JS.add_class(theme.light_bg_color)
  end

  defp toggle_position_on(js \\ %JS{}) do
    js
    |> JS.remove_class("translate-x-0")
    |> JS.add_class("translate-x-6")
  end

  defp toggle_position_off(js \\ %JS{}) do
    js
    |> JS.remove_class("translate-x-6")
    |> JS.add_class("translate-x-0")
  end
end
