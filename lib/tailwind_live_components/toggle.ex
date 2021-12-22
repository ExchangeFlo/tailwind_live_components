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
    * `error` - Optional error message
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
        class={"#{background(@selected_value)} relative inline-flex flex-shrink-0 h-8 w-14 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sky-900"}
        :class="{
          'bg-sky-900/75': on,
          'bg-gray-200': !(on)
        }"
        role="switch"
        tabindex="0"
        :aria-checked="on.toString()"
        aria-labelledby={@label_id}
      >
        <span
          aria-hidden="true"
          class={"#{position(@selected_value)} pointer-events-none inline-block h-7 w-7 rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200"}
          :class="{
            'translate-x-6': on,
            'translate-x-0': !(on)
          }"
        ></span>
      </div>

      <span class="ml-3">
        <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />
      </span>
    </div>
    """
  end

  defp background("true"), do: "bg-sky-900/75"
  defp background(_), do: "bg-gray-200"

  defp position("true"), do: "translate-x-6"
  defp position(_), do: "translate-x-0"
end
