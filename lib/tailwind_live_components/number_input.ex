defmodule TailwindLiveComponents.NumberInput do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias TailwindLiveComponents.Label

  @doc """
  Renders the number input

  ```
  <.number_input form={f} field={:value} label="Number Input" min="5" max="10" step="2" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `required` - Optional flag idicating field is required
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `detail` - Optional detail shown below the input
    * `min` - min value for input
    * `max` - max value for input
    * `step` - Optional step for input
    * `value` - Optional field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def number_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <div id={@input_id <> "-container"}>
      <Label.label
        form={@form}
        field={@field}
        theme={@theme}
        label={@label}
        required={@required}
        input_id={@input_id}
        label_id={@label_id}
        error={@error}
      />

      <div class="relative mt-1 rounded-md shadow-sm">
        <%= Phoenix.HTML.Form.number_input(
          @form,
          @field,
          id: @input_id,
          tabindex: 0,
          min: @min,
          max: @max,
          step: @step,
          value: @value,
          autocomplete: @autocomplete,
          placeholder: @placeholder,
          class: "#{@theme.bg_color} #{@theme.text_color} relative w-full border #{@theme.border_color} rounded-md shadow-sm px-3 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md "
        ) %>
      </div>

      <.detail {assigns} />
    </div>
    """
  end

  @doc """
  Renders the slider number input

  ```
  <.slider form={f} field={:value} label="Slider Input" min="10" max="100" step="2" prefix="$" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `required` - Optional flag idicating field is required
    * `min` - min value for input
    * `max` - max value for input
    * `step` - Optional step for input
    * `prefix` - Optional prefix
    * `value` - Optional field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def slider(assigns) do
    assigns = load_assigns(assigns)
    value = parse_value(Map.get(assigns, :value) || Map.get(assigns, :min))
    min = parse_value(Map.get(assigns, :min))
    max = parse_value(Map.get(assigns, :max))

    assigns = assign(assigns, :thumb_position, (value - min) / (max - min) * 96)

    ~H"""
    <div
      id={@input_id <> "-container"}
      phx-hook="tlcSlider"
    >
      <Label.label
        form={@form}
        field={@field}
        theme={@theme}
        label={@label}
        required={@required}
        input_id={@input_id}
        label_id={@label_id}
        error={@error}
      />

      <div class="relative w-full mt-4">
        <%= Phoenix.HTML.Form.range_input(
          @form,
          @field,
          id: @input_id,
          min: @min,
          max: @max,
          step: @step,
          value: @value,
          role: "slider",
          tabindex: 0,
          "data-tlc-ref": "valueInput",
          "aria-valuemin": @min,
          "aria-valuemax": @max,
          "aria-valuenow": @value,
          class: "absolute appearance-none z-20 left-2 h-7 w-full opacity-0 cursor-pointer"
        ) %>

        <div for={@input_id} class="relative z-10 h-2">
          <div class={"absolute z-10 left-0 h-3 right-0 bottom-0 top-0 rounded-lg #{@theme.selected_bg_color}"}></div>
          <div
            data-tlc-ref="bar"
            class={"absolute z-20 top-0 h-3 bottom-0 rounded-lg #{@theme.light_bg_color}"}
            style={"left:#{@thumb_position}%; right:0%"}>
          </div>
          <div
            data-tlc-ref="thumb"
            class={"absolute z-30 w-7 h-7 border-4 #{@theme.selected_dark_border_color} border-opacity-100 #{@theme.selected_dark_bg_color} rounded-full -mt-2"}
            data-active={active_thumb(@theme)}
            data-inactive={inactive_thumb(@theme)}
            style={"left: #{@thumb_position}%"}
          ></div>
        </div>

        <div class={"flex items-center justify-between pt-6 space-x-4 text-md #{@theme.text_color}"}>
          <span><%= @prefix %><%= Number.Delimit.number_to_delimited(@min, precision: 0) %></span>

          <span class="flex font-semibold text-2xl">
            <%= if @prefix do %>
              <span><%= @prefix %></span>
            <% end %>
            <span data-tlc-ref="display">
              <%= Number.Delimit.number_to_delimited(@value, precision: 0) %>
            </span>
          </span>

          <span><%= @prefix %><%= Number.Delimit.number_to_delimited(@max, precision: 0) %></span>
        </div>
      </div>
    </div>
    """
  end

  defp detail(%{detail: nil} = assigns), do: ~H""

  defp detail(assigns) do
    ~H"""
    <span class={"#{@theme.light_text_color} text-sm mt-0.5 pl-1"}>
      <%= @detail %>
    </span>
    """
  end

  defp load_assigns(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"
    value = parse_value(Map.get(assigns, :value) || Map.get(assigns, :min))

    assigns
    |> assign_new(:input_id, fn -> input_id end)
    |> assign_new(:label_id, fn -> label_id end)
    |> assign_new(:label, fn -> nil end)
    |> assign_new(:required, fn -> false end)
    |> assign_new(:value, fn -> value end)
    |> assign_new(:autocomplete, fn -> "off" end)
    |> assign_new(:step, fn -> 1 end)
    |> assign_new(:placeholder, fn -> nil end)
    |> assign_new(:prefix, fn -> nil end)
    |> assign_new(:error, fn -> nil end)
    |> assign_new(:detail, fn -> nil end)
    |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)
  end

  defp active_thumb(js \\ %JS{}, theme), do: JS.add_class(js, "ring-2 ring-offset-2 #{theme.selected_ring_color} ring-opacity-100")

  defp inactive_thumb(js \\ %JS{}, theme), do: JS.remove_class(js, "ring-2 ring-offset-2 #{theme.selected_ring_color} ring-opacity-100")

  defp parse_value(value, default \\ 0)
  defp parse_value(%Decimal{} = value, _default), do: Decimal.to_integer(value)
  defp parse_value(value, _default) when is_integer(value), do: value
  defp parse_value(value, _default) when is_bitstring(value), do: String.to_integer(value)
  defp parse_value(nil, default), do: default
end
