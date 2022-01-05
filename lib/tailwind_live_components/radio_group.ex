defmodule TailwindLiveComponents.RadioGroup do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias TailwindLiveComponents.Label

  @doc """
  Renders the vertical radio group element

  ```
  <.radio_group form={f} field={:fruit} label="Horizontal Radio Group" options={[
    %{value: "apple", display: "Apple", detail: "yummy apple"},
    %{value: "banana", display: "Banana", detail: "yummy banana"},
    %{value: "cherry", display: "Cherry", detail: "yummy cherry"}
  ]} />
  ```

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `value` - The current value for the input
    * `orientation` - "vertical" or "horizontal" (default is "vertical")
    * `prompt` - An option to include at the top of the options with the given prompt text
    * `options` - The options in the list box
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def radio_group(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"
    options = Map.get(assigns, :options, [])

    assigns =
      assigns
      |> assign(:options, options)
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:value, fn -> nil end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)
      |> assign_new(:orientation, fn -> "vertical" end)

    ~H"""
    <div
      id={@input_id <> "-container"}
      phx-hook="tlcRadioGroup"
      role="radiogroup"
      aria-labelledby={@label_id}
    >
      <%= Phoenix.HTML.Form.hidden_input(
        @form,
        @field,
        id: @input_id,
        value: @value,
        "tlc-ref": "valueInput"
      ) %>

      <Label.label
        form={@form}
        field={@field}
        theme={@theme}
        label={@label}
        input_id={@input_id}
        label_id={@label_id}
        error={@error}
      />

      <%= if @orientation == "horizontal" do %>
        <div
          class={"mt-1 grid grid-cols-1 gap-y-2 #{grid_columns(@options)} sm:gap-x-2"}
          role="none"
          tlc-ref="radiogroup"
        >
          <%= for {option, index} <- Enum.with_index(@options) do %>
            <.horizontal_radio_option
              option={option}
              selected={option.value == @value}
              option_id={"#{@input_id}-option-#{index}"}
              theme={@theme}
            />
          <% end %>
        </div>
      <% else %>
        <div
          class="mt-1 space-y-2"
          role="none"
          tlc-ref="radiogroup"
        >
          <%= for {option, index} <- Enum.with_index(@options) do %>
            <.vertical_radio_option
              option={option}
              selected={option.value == @value}
              option_id={"#{@input_id}-option-#{index}"}
              theme={@theme}
            />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp vertical_radio_option(assigns) do
    assigns =
      assigns
      |> assign_new(:option_label_id, fn -> assigns.option_id <> "-label" end)
      |> assign_new(:option_description_id, fn -> assigns.option_id <> "-description" end)
      |> assign_new(:option_value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:option_display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:option_detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="radio"
      aria-checked={@selected}
      tabindex="0"
      aria-labelledby={@option_label_id}
      aria-describedby={@option_description_id}
      data-value={@option_value}
      class={"relative flex px-5 py-4 rounded-lg shadow-sm cursor-pointer focus:outline-none border focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md"}
      data-radiogroup-option-selected={radiogroup_option_color_selected(@theme)}
      data-radiogroup-option-not-selected={radiogroup_option_color_not_selected(@theme)}
    >
      <div class="flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="text-md">
            <p
              id={@option_label_id}
              class="font-medium"
              data-radiogroup-option-selected={radiogroup_option_display_selected(@theme)}
              data-radiogroup-option-not-selected={radiogroup_option_display_not_selected(@theme)}
            >
              <%= @option_display %>
            </p>
            <%= if @option_detail do %>
              <span
                id={@option_description_id}
                class="inline text-sm"
                data-radiogroup-option-selected={radiogroup_option_display_selected(@theme)}
                data-radiogroup-option-not-selected={radiogroup_option_display_not_selected(@theme)}
              >
                <span><%= @option_detail %></span>
              </span>
            <% end %>
          </div>
        </div>
        <div
          class={"flex-shrink-0 #{@theme.selected_text_color}"}
          data-radiogroup-option-selected={radiogroup_option_check_selected()}
          data-radiogroup-option-not-selected={radiogroup_option_check_not_selected()}
        >
          <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="12" fill="#fff" fill-opacity="0.2"></circle>
            <path d="M7 13l3 3 7-7" stroke="#fff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
          </svg>
        </div>
      </div>
    </div>
    """
  end

  defp horizontal_radio_option(assigns) do
    assigns =
      assigns
      |> assign_new(:option_label_id, fn -> assigns.option_id <> "-label" end)
      |> assign_new(:option_description_id, fn -> assigns.option_id <> "-description" end)
      |> assign_new(:option_value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:option_display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:option_detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="radio"
      aria-checked={@selected}
      tabindex="0"
      aria-labelledby={@option_label_id}
      aria-describedby={@option_description_id}
      data-value={@option_value}
      class={"relative flex px-5 py-4 rounded-lg shadow-sm cursor-pointer focus:outline-none border focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md"}
      data-radiogroup-option-selected={radiogroup_option_color_selected(@theme)}
      data-radiogroup-option-not-selected={radiogroup_option_color_not_selected(@theme)}
    >
      <div class="flex justify-between w-full">
        <div class="flex-1 flex">
          <div class="flex flex-col">
            <span
              id={@option_label_id}
              class="font-medium text-md"
              data-radiogroup-option-selected={radiogroup_option_display_selected(@theme)}
              data-radiogroup-option-not-selected={radiogroup_option_display_not_selected(@theme)}
            >
              <%= @option_display %>
            </span>
            <%= if @option_detail do %>
              <span
                id={@option_description_id}
                class="inline text-sm"
                data-radiogroup-option-selected={radiogroup_option_detail_selected(@theme)}
                data-radiogroup-option-not-selected={radiogroup_option_detail_not_selected(@theme)}
              >
                <span><%= @option_detail %></span>
              </span>
            <% end %>
          </div>
        </div>
        <svg
          viewBox="0 0 24 24"
          fill="none"
          class="w-6 h-6"
          data-radiogroup-option-selected={radiogroup_option_check_selected()}
          data-radiogroup-option-not-selected={radiogroup_option_check_not_selected()}
        >
          <circle cx="12" cy="12" r="12" fill="#fff" fill-opacity="0.2"></circle>
          <path d="M7 13l3 3 7-7" stroke="#fff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
        </svg>
      </div>
    </div>
    """
  end

  defp grid_columns(options) do
    case length(options) do
      0 -> "sm:grid-cols-1"
      1 -> "sm:grid-cols-1"
      2 -> "sm:grid-cols-2"
      3 -> "sm:grid-cols-3"
      4 -> "sm:grid-cols-4"
      5 -> "sm:grid-cols-5"
      6 -> "sm:grid-cols-6"
      7 -> "sm:grid-cols-7"
      8 -> "sm:grid-cols-8"
      9 -> "sm:grid-cols-9"
      10 -> "sm:grid-cols-10"
      11 -> "sm:grid-cols-11"
      12 -> "sm:grid-cols-12"
      _ -> "sm:grid-cols-12"
    end
  end

  defp radiogroup_option_color_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class("#{theme.bg_color} #{theme.border_color}")
    |> JS.add_class("#{theme.selected_bg_color} #{theme.focus_selected_shadow_color} #{theme.selected_border_color}")
  end

  defp radiogroup_option_color_not_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class("#{theme.selected_bg_color} #{theme.focus_selected_shadow_color} #{theme.selected_border_color}")
    |> JS.add_class("#{theme.bg_color} #{theme.border_color}")
  end

  defp radiogroup_option_display_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.text_color)
    |> JS.add_class(theme.selected_text_color)
  end

  defp radiogroup_option_display_not_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_text_color)
    |> JS.add_class(theme.text_color)
  end

  defp radiogroup_option_detail_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.light_text_color)
    |> JS.add_class(theme.selected_light_text_color)
  end

  defp radiogroup_option_detail_not_selected(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_light_text_color)
    |> JS.add_class(theme.light_text_color)
  end

  defp radiogroup_option_check_selected(js \\ %JS{}) do
    JS.remove_class(js, "invisible")
  end

  defp radiogroup_option_check_not_selected(js \\ %JS{}) do
    JS.add_class(js, "invisible")
  end
end
