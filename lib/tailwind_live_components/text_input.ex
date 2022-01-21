defmodule TailwindLiveComponents.TextInput do
  use Phoenix.Component

  alias TailwindLiveComponents.Label

  @doc """
  Renders the text input

  ```
  <.text_input form={f} field={:fruit} placeholder="Fruit" label="Fruit" error="test error message" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def text_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div class="relative mt-1 rounded-md shadow-sm">
      <%= Phoenix.HTML.Form.text_input(
        @form,
        @field,
        id: @input_id,
        autocomplete: @autocomplete,
        value: @value,
        placeholder: @placeholder,
        class: input_class(@theme)
      ) %>
    </div>

    <.detail {assigns} />
    """
  end

  @doc """
  Renders the textarea

  ```
  <.textarea form={f} field={:fruit} placeholder="Select Fruit" label="Textarea" value="This is a test text area" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def textarea(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div class="relative mt-1 rounded-md shadow-sm">
      <%= Phoenix.HTML.Form.textarea(
        @form,
        @field,
        id: @input_id,
        autocomplete: @autocomplete,
        value: @value,
        rows: 3,
        placeholder: @placeholder,
        class: input_class(@theme)
      ) %>
    </div>

    <.detail {assigns} />
    """
  end

  @doc """
  Renders the tel input with masking

  ```
  <.tel_input form={f} field={:phone} label="Tel Input" value="555234" />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Option error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def tel_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div
      id={@input_id <> "-container"}
      phx-hook="tlcTelInput"
      class="relative mt-1 rounded-md shadow-sm"
    >
      <%= Phoenix.HTML.Form.hidden_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        "data-tlc-ref": "valueInput"
      ) %>

      <input
        type="text"
        data-tlc-ref="displayInput"
        autocomplete={@autocomplete},
        class={input_class(@theme) <> " pl-9"}
        placeholder={@placeholder}
      />
      <div class="absolute inset-y-0 left-0 pl-3 py-2 flex items-center pointer-events-none">
        <span class={"#{@theme.light_text_color} sm:text-lg"}>+1</span>
      </div>
    </div>

    <.detail {assigns} />
    """
  end

  @doc """
  Renders the date input with masking

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Option error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def date_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div class="relative mt-1 rounded-md shadow-sm">
      <%= Phoenix.HTML.Form.date_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        autocomplete: @autocomplete,
        class: input_class(@theme)
      ) %>
    </div>

    <.detail {assigns} />
    """
  end

  @doc """
  Renders the zip input with masking

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `value` - The current value for the input
    * `autocomplete` - Optional autocomplete attribute
    * `label` - The text for the generated `<label>` element
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Option error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def zip_input(assigns) do
    assigns = load_assigns(assigns)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div
      id={@input_id <> "-container"}
      phx-hook="tlcZipInput"
      class="relative mt-1 rounded-md shadow-sm"
    >
      <%= Phoenix.HTML.Form.text_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        placeholder: @placeholder,
        class: input_class(@theme),
        autocomplete: @autocomplete,
        "data-tlc-ref": "valueInput"
      ) %>
    </div>

    <.detail {assigns} />
    """
  end

  @doc """
  Renders the address input with Google Places API autocomplete

  Requires setup of Google Places API: https://developers.google.com/maps/documentation/javascript/places-autocomplete

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `value` - The current value for the input
    * `api_key` - Google Places API Key
    * `latitude` - The latitude for the center point of the Places search
    * `longitude` - The longitude for the center point of the Places search
    * `country_code` - The country code to restrict Google Place search to (default is 'us')
    * `label` - The text for the generated `<label>` element
    * `detail` - Optional detail shown below the input
    * `placeholder` - Optional placeholder
    * `error` - Option error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def address_input(assigns) do
    assigns = assigns |> load_assigns() |> assign_new(:country_code, fn -> "us" end)

    ~H"""
    <Label.label
      form={@form}
      field={@field}
      theme={@theme}
      label={@label}
      input_id={@input_id}
      label_id={@label_id}
      error={@error}
    />

    <div
      id={@input_id <> "-container"}
      phx-hook="tlcAddressInput"
      data-api-key={@api_key}
      data-latitude={@latitude}
      data-longitude={@longitude}
      data-country-code={@country_code}
      class="relative mt-1 rounded-md shadow-sm"
    >
      <%= Phoenix.HTML.Form.text_input(
        @form,
        @field,
        id: @input_id,
        autocomplete: "off",
        value: @value,
        placeholder: @placeholder,
        class: input_class(@theme),
        "data-tlc-ref": "valueInput"
      ) %>
    </div>

    <.detail {assigns} />
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

  defp input_class(theme),
    do: "#{theme.bg_color} #{theme.text_color} relative w-full border #{theme.border_color} rounded-md shadow-sm px-3 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 #{theme.focus_ring_color} #{theme.focus_border_color} focus:shadow-md"

  defp load_assigns(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    assigns
    |> assign_new(:input_id, fn -> input_id end)
    |> assign_new(:label_id, fn -> label_id end)
    |> assign_new(:label, fn -> nil end)
    |> assign_new(:value, fn -> nil end)
    |> assign_new(:autocomplete, fn -> "off" end)
    |> assign_new(:placeholder, fn -> nil end)
    |> assign_new(:error, fn -> nil end)
    |> assign_new(:detail, fn -> nil end)
    |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)
  end
end
