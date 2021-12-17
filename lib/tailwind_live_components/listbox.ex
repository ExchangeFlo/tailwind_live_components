defmodule TailwindLiveComponents.Listbox do
  use Phoenix.Component

  @moduledoc """
  <.listbox form={:basket} field={:fruit} prompt="Select Fruit" options={[
      %{value: "apple", display: "Apple"},
      %{value: "banana", display: "Banana"},
      %{value: "cherry", display: "Cherry"}
    ]} />
  """

  @doc """
  Renders the listbox element

  ## Options

    * `form` - The form identifier
    * `field` - The field name
    * `label` - The text for the generated `<label>` element
    * `prompt` - An option to include at the top of the options with the given prompt text
    * `options` - The options in the list box
  """
  def listbox(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    prompt = Map.get(assigns, :prompt, Phoenix.HTML.raw("&nbsp;"))
    options = Map.get(assigns, :options, [])

    selected_value = Phoenix.HTML.Form.input_value(assigns.form, assigns.field)
    selected_index = Enum.find_index(options, fn %{value: value} -> value == selected_value end)
    selected_display = if(selected_index, do: options |> Enum.at(selected_index) |> Map.get(:display), else: prompt)

    assigns =
      assigns
      |> assign(:options, options)
      |> assign_new(:input_id, fn -> input_id end)
      |> assign_new(:selected_value, fn -> selected_value end)
      |> assign_new(:selected_index, fn -> selected_index end)
      |> assign_new(:selected_display, fn -> selected_display end)
      |> assign_new(:label_id, fn -> label_id end)

    ~H"""
    <div
      x-data={"TailwindLiveComponents.listbox({
        open: false,
        selectedIndex: #{@selected_index || "null"},
        activeIndex: #{@selected_index || "null"}
      })"}
      x-init="init()"
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "selectedValue") %>

      <label id={@label_id} class="block text-sm font-medium text-gray-700" @click="$refs.button.focus()">
        <%= @label %>
      </label>
      <div class="mt-1 relative">
        <button
          type="button"
          class="bg-white relative w-full border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          x-ref="button"
          @keydown.arrow-up.stop.prevent="onButtonClick()"
          @keydown.arrow-down.stop.prevent="onButtonClick()"
          @click="onButtonClick()"
          aria-haspopup="listbox"
          :aria-expanded="open"
          aria-labelledby={@label_id}
        >
          <span x-text="selectedDisplay" class="block truncate"><%= @selected_display %></span>
          <span class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
            <Heroicons.Solid.selector class="h-5 w-5 text-gray-400" />
          </span>
        </button>
        <ul
          x-show="open"
          x-transition:leave="transition ease-in duration-100"
          x-transition:leave-start="opacity-100"
          x-transition:leave-end="opacity-0"
          class="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
          @click.away="open = false"
          @keydown.enter.stop.prevent="onOptionSelect()"
          @keydown.space.stop.prevent="onOptionSelect()"
          @keydown.escape="onEscape()"
          @keydown.arrow-up.prevent="onArrowUp()"
          @keydown.arrow-down.prevent="onArrowDown()"
          x-ref="listbox"
          tabindex="-1"
          role="listbox"
          aria-labelledby={@label_id}
          :aria-activedescendant="activeDescendant"
          aria-activedescendant="listbox-option-8"
          style="display: none;"
        >
          <%= for {%{value: value, display: display}, index} <- Enum.with_index(@options) do %>
            <.listbox_option
              value={value}
              display={display}
              index={index}
              option_id={"#{@input_id}-option-#{index}"}
              selected={value == @selected_value}
            />
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  @doc """
  prop value
  prop display
  prop index
  prop selected, :boolean, default: false
  prop option_id
  """
  def listbox_option(assigns) do
    ~H"""
    <li
      id={@option_id}
      role="option"
      @click={"choose(#{@index})"}
      @mouseenter={"activeIndex = #{@index}"}
      @mouseleave="activeIndex = null"
      data-value={@value}
      data-display={@display}
      class={"cursor-default select-none relative py-2 pl-3 pr-9 #{option_classes(@selected, "bg-indigo-600")}"}
      :class={"{ 'text-white bg-indigo-600': activeIndex === #{@index}, 'text-gray-900': !(activeIndex === #{@index}) }"}
    >
      <span
        class={"#{text_classes(@selected)} block truncate"}
        :class={"{ 'font-semibold': selectedIndex === #{@index}, 'font-normal': !(selectedIndex === #{@index}) }"}
      >
        <%= @display %>
      </span>

      <span
        class={"absolute inset-y-0 right-0 flex items-center pr-4 #{checkbox_classes(@selected, "text-indigo-600")}"}
        :class={"{ 'text-white': activeIndex === #{@index}, 'text-indigo-600': !(activeIndex === #{@index}) }"}
        x-show={"selectedIndex === #{@index}"}
        style={unless @selected, do: "display: none;"}
      >
        <Heroicons.Solid.check class="h-5 w-5" />
      </span>
    </li>
    """
  end

  defp option_classes(selected, bg_color_class), do: if(selected, do: "text-white #{bg_color_class}", else: "text-gray-900")
  defp text_classes(selected), do: if(selected, do: "font-semibold", else: "font-normal")
  defp checkbox_classes(selected, text_color_class), do: if(selected, do: "text-white", else: text_color_class)
end
