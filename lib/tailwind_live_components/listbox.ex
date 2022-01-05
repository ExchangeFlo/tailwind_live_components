defmodule TailwindLiveComponents.Listbox do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias TailwindLiveComponents.Label

  @doc """
  Renders the listbox element

  ```
  <.listbox form={:basket} field={:fruit} prompt="Select Fruit" options={[
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
    * `detail` - Optional detail shown below the input
    * `prompt` - An option to include at the top of the options with the given prompt text
    * `options` - The options in the list box
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
  """
  def listbox(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    prompt = Map.get(assigns, :prompt)
    options = Map.get(assigns, :options, [])

    value = Map.get(assigns, :value, nil)
    selected_index = Enum.find_index(options, fn %{value: option_value} -> value == option_value end)
    selected_display = if(selected_index, do: options |> Enum.at(selected_index) |> Map.get(:display), else: prompt)

    assigns =
      assigns
      |> assign(:options, options)
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:selected_value, fn -> value end)
      |> assign_new(:selected_index, fn -> selected_index end)
      |> assign_new(:selected_display, fn -> selected_display end)
      |> assign_new(:prompt, fn -> prompt end)
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:detail, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div
      id={@input_id <> "-container"}
      phx-hook="tlcListbox"
    >
      <%= Phoenix.HTML.Form.hidden_input(
        @form,
        @field,
        id: @input_id,
        value: @selected_value,
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

      <div class="mt-1 relative">
        <div
          tlc-ref="button"
          tabindex="0"
          aria-haspopup="listbox"
          aria-expanded="false"
          aria-labelledby={@label_id}
          class={"#{@theme.bg_color} #{@theme.text_color} relative w-full border #{@theme.border_color} rounded-md shadow-sm pl-3 pr-10 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md "}
        >
          <span tlc-ref="selectedText" class="block truncate"><%= @selected_display %></span>
          <span class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
            <svg xmlns="http://www.w3.org/2000/svg" class={"h-5 w-5 #{@theme.lighter_text_color}"} viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </span>
        </div>
        <div
          data-listbox-open={listbox_open()}
          data-listbox-close={listbox_close()}
          tlc-ref="listbox"
          tabindex="-1"
          role="listbox"
          aria-labelledby={@label_id}
          aria-activedescendant=""
          style="display: none;"
          class={"absolute z-10 mt-1 w-full #{@theme.bg_color} shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-md transition"}
        >
          <%= for {%{value: value} = option, index} <- Enum.with_index(@options) do %>
            <.listbox_option
              option={option}
              index={index}
              option_id={"#{@input_id}-option-#{index}"}
              selected={value == @selected_value}
              theme={@theme}
            />
          <% end %>
        </div>
      </div>
    </div>

    <.detail {assigns} />
    """
  end

  defp listbox_option(assigns) do
    assigns =
      assigns
      |> assign_new(:value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="option"
      data-value={@option.value}
      data-display={@option.display}
      class={"cursor-default select-none relative py-2 pl-3 pr-9 #{option_classes(@theme, @selected)}"}
      data-listbox-option-active={listbox_option_background_active(@theme)}
      data-listbox-option-inactive={listbox_option_background_inactive(@theme)}
    >
      <div class="flex items-baseline">
        <span
          class={"#{text_classes(@selected)} block truncate"}
          data-listbox-option-selected={listbox_option_text_selected()}
          data-listbox-option-not-selected={listbox_option_text_not_selected()}
        >
          <%= @display %>
        </span>
        <%= if @detail do %>
          <span
            class={"#{detail_classes(@theme, @selected)} ml-2 truncate text-sm"}
            data-listbox-option-active={listbox_option_detail_active(@theme)}
            data-listbox-option-inactive={listbox_option_detail_inactive(@theme)}
          >
            <%= @detail %>
          </span>
        <% end %>
      </div>

      <span
        class={"absolute inset-y-0 right-0 flex items-center pr-4 invisible #{checkbox_classes(@theme, @selected)}"}
        data-listbox-option-selected={JS.remove_class("invisible")}
        data-listbox-option-not-selected={JS.add_class("invisible")}
        data-listbox-option-active={listbox_option_checkbox_active(@theme)}
        data-listbox-option-inactive={listbox_option_checkbox_inactive(@theme)}
      >
        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
          <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
        </svg>
      </span>
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

  defp listbox_open(js \\ %JS{}), do: JS.show(js, to: "[tlc-ref='listbox']")

  defp listbox_close(js \\ %JS{}), do: JS.hide(js, to: "[tlc-ref='listbox']", transition: {"ease-in duration-100", "opacity-100", "opacity-0"})

  defp listbox_option_background_active(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.text_color)
    |> JS.add_class("#{theme.selected_text_color} #{theme.selected_bg_color}")
  end

  defp listbox_option_background_inactive(js \\ %JS{}, theme) do
    js
    |> JS.remove_class("#{theme.selected_text_color} #{theme.selected_bg_color}")
    |> JS.add_class(theme.text_color)
  end

  defp listbox_option_text_selected(js \\ %JS{}) do
    js
    |> JS.remove_class("font-normal")
    |> JS.add_class("font-semibold")
  end

  defp listbox_option_text_not_selected(js \\ %JS{}) do
    js
    |> JS.remove_class("font-semibold")
    |> JS.add_class("font-normal")
  end

  defp listbox_option_detail_active(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.light_text_color)
    |> JS.add_class(theme.selected_light_text_color)
  end

  defp listbox_option_detail_inactive(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_light_text_color)
    |> JS.add_class(theme.light_text_color)
  end

  defp listbox_option_checkbox_active(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_highlight_text_color)
    |> JS.add_class(theme.selected_text_color)
  end

  defp listbox_option_checkbox_inactive(js \\ %JS{}, theme) do
    js
    |> JS.remove_class(theme.selected_light_text_color)
    |> JS.add_class(theme.selected_highlight_text_color)
  end

  defp option_classes(theme, selected), do: if(selected, do: "#{theme.selected_text_color} #{theme.selected_bg_color}", else: theme.text_color)

  defp detail_classes(theme, active), do: if(active, do: theme.selected_light_text_color, else: theme.light_text_color)

  defp checkbox_classes(theme, selected), do: if(selected, do: theme.selected_text_color, else: theme.selected_highlight_text_color)

  defp text_classes(selected), do: if(selected, do: "font-semibold", else: "font-normal")
end
