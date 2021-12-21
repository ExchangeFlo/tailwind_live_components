defmodule TailwindLiveComponents.TextInput do
  use Phoenix.Component

  alias TailwindLiveComponents.Label

  @doc """
  Renders the text input

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - Option field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
  """
  def text_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div class="mt-1">
      <%= Phoenix.HTML.Form.text_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        placeholder: @placeholder,
        class: input_class(),
        data: [focus: true]
      ) %>
    </div>
    """
  end

  @doc """
  Renders the textarea

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - Option field value
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
  """
  def textarea(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div class="mt-1">
      <%= Phoenix.HTML.Form.textarea(
        @form,
        @field,
        id: @input_id,
        value: @value,
        rows: 3,
        placeholder: @placeholder,
        class: input_class(),
        data: [focus: true]
      ) %>
    </div>
    """
  end

  @doc """
  Renders the tel input with masking

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - Option field value
    * `placeholder` - Optional placeholder
    * `error` - Option error message
  """
  def tel_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div
      x-data={"TailwindLiveComponents.telInput()"}
      class="relative mt-1 rounded-md shadow-sm"
    >
      <%= Phoenix.HTML.Form.hidden_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        "x-model": "value",
        "x-ref": "valueInput"
      ) %>

      <input
        type="text"
        x-model="display"
        @input.prevent.stop="onValueChanged"
        class={input_class() <> " pl-9"}
        placeholder={@placeholder}
        data-focus="true"
      />
      <div class="absolute inset-y-0 left-0 pl-3 py-2 flex items-center pointer-events-none">
        <span class="text-gray-500 sm:text-lg">+1</span>
      </div>
    </div>
    """
  end

  @doc """
  Renders the date input with masking

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `placeholder` - Optional placeholder
    * `error` - Option error message
  """
  def date_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div class="relative mt-1 rounded-md shadow-sm">
      <%= Phoenix.HTML.Form.date_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        class: input_class(),
        data: [focus: true]
      ) %>
    </div>

    """
  end

  @doc """
  Renders the zip input with masking

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `placeholder` - Optional placeholder
    * `error` - Option error message
  """
  def zip_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

    <div
      x-data={"TailwindLiveComponents.zipInput()"}
      class="relative mt-1 flex justify-center"
    >
      <%= Phoenix.HTML.Form.text_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        placeholder: @placeholder,
        class: input_class(),
        "@input.prevent.stop": "onValueChanged",
        "x-ref": "valueInput",
        "x-model": "value",
        data: [focus: true]
      ) %>
    </div>
    """
  end

  defp input_class(), do: "bg-white relative w-full border border-gray-300 rounded-md shadow-sm px-3 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 focus:ring-sky-900 focus:border-sky-900 focus:shadow-sky-900/50 focus:shadow-md "

  defp load_assigns(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    assigns
    |> assign_new(:input_id, fn -> input_id end)
    |> assign_new(:label_id, fn -> label_id end)
    |> assign_new(:value, fn -> nil end)
    |> assign_new(:placeholder, fn -> nil end)
    |> assign_new(:error, fn -> nil end)
  end
end
