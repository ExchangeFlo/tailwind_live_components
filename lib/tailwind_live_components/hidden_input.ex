defmodule TailwindLiveComponents.HiddenInput do
  use Phoenix.Component

  @doc """
  Renders the hidden input

  ```
  <.hidden_input form={f} field={:fruit}  />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `value` - The current value for the input
  """
  def hidden_input(assigns) do
    assigns = assign_new(assigns, :input_id, fn -> Phoenix.HTML.Form.input_id(assigns.form, assigns.field) end)

    ~H"""
    <%= Phoenix.HTML.Form.hidden_input(
      @form,
      @field,
      id: @input_id,
      tabindex: -1,
      value: @value
    ) %>
    """
  end
end
