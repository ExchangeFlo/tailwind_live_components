defmodule TailwindLiveComponents.NumberInput do
  use Phoenix.Component

  alias TailwindLiveComponents.Label

  @doc """
  Renders the number input

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `min` - min value for input
    * `max` - max value for input
    * `step` - Optional step for input
    * `value` - Optional field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
  """
  def number_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <%= Phoenix.HTML.Form.number_input(
      @form,
      @field,
      id: @input_id,
      min: @min,
      max: @max,
      step: @step,
      value: @value,
      placeholder: @placeholder,
      class: input_class(),
      data: [focus: true]
    ) %>
    """
  end

  @doc """
  Renders the slider number input

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `min` - min value for input
    * `max` - max value for input
    * `step` - Optional step for input
    * `prefix` - Optional prefix
    * `value` - Optional field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
  """
  def slider(assigns) do
    assigns = load_assigns(assigns)
    value = parse_value(Map.get(assigns, :value) || Map.get(assigns, :min))
    min = parse_value(Map.get(assigns, :min))
    max = parse_value(Map.get(assigns, :max))

    assigns = assign(assigns, :thumb_position, (value - min) / (max - min) * 96)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div class="mt-1">
      <div
        x-data={"TailwindLiveComponents.slider({
          prefix: '#{@prefix}',
          min: #{@min},
          max: #{@max},
          value: #{@value},
          thumb: #{@thumb_position}
        })"}
        class="relative w-full"
      >
        <div class="flex justify-center items-center">
          <div
            x-ref="display"
            class="mb-8 font-semibold text-2xl"
          >
            <%= @prefix %><%= Number.Delimit.number_to_delimited(@value, precision: 0) %>
          </div>
        </div>
        <div class="group">
          <%= Phoenix.HTML.Form.range_input(
            @form,
            @field,
            min: @min,
            max: @max,
            step: @step,
            value: @value,
            "@input": "valueChanged",
            "@focus": "active = true",
            "@blur": "active = false",
            class: "absolute appearance-none z-20 left-2 h-7 w-full opacity-0 cursor-pointer",
            data: [focus: true]
          ) %>

          <div class="relative z-10 h-2">
            <div class="absolute z-10 left-0 h-3 right-0 bottom-0 top-0 rounded-lg bg-sky-900/75"></div>
            <div
              x-ref="bar"
              class="absolute z-20 top-0 h-3 bottom-0 rounded-lg bg-gray-200"
              style={"left:#{@thumb_position}%; right:0%"}>
            </div>
            <div
              x-ref="thumb"
              class="absolute z-30 w-7 h-7 border-4 border-sky-900 border-opacity-100 bg-sky-900 rounded-full -mt-2"
              :class="{'ring-2 ring-offset-2 ring-sky-900 ring-opacity-100': active}"
              style={"left: #{@thumb_position}%"}
            ></div>
          </div>
        </div>

        <div class="flex items-center justify-between pt-5 space-x-4 text-sm text-gray-700">
          <span><%= @prefix %><%= Number.Delimit.number_to_delimited(@min, precision: 0) %></span>
          <span><%= @prefix %><%= Number.Delimit.number_to_delimited(@max, precision: 0) %></span>
        </div>
      </div>
    </div>
    """
  end

  defp input_class(), do: "bg-white relative w-full border border-gray-300 rounded-md shadow-sm px-3 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 focus:ring-sky-900 focus:border-sky-900 focus:shadow-sky-900/50 focus:shadow-md "

  defp load_assigns(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"
    default_value = parse_value(Map.get(assigns, :value) || Map.get(assigns, :min))

    assigns
    |> assign_new(:input_id, fn -> input_id end)
    |> assign_new(:label_id, fn -> label_id end)
    |> assign_new(:value, fn -> default_value end)
    |> assign_new(:step, fn -> 1 end)
    |> assign_new(:placeholder, fn -> nil end)
    |> assign_new(:prefix, fn -> nil end)
    |> assign_new(:error, fn -> nil end)
  end

  defp parse_value(value, default \\ 0)
  defp parse_value(%Decimal{} = value, _default), do: Decimal.to_integer(value)
  defp parse_value(value, _default) when is_integer(value), do: value
  defp parse_value(value, _default) when is_bitstring(value), do: String.to_integer(value)
  defp parse_value(nil, default), do: default
end
