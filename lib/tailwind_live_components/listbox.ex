defmodule TailwindLiveComponents.Listbox do
  use Phoenix.Component

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
    * `prompt` - An option to include at the top of the options with the given prompt text
    * `options` - The options in the list box
    * `error` - Optional error message
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
      |> assign_new(:prompt, fn -> prompt end)
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:error, fn -> nil end)

    ~H"""
    <div
      x-data={"TailwindLiveComponents.listbox({
        selectedIndex: #{@selected_index || "null"},
        activeIndex: #{@selected_index || "null"},
        prompt: '#{@prompt}',
      })"}
      x-init="init()"
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "selectedValue") %>

      <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

      <div class="mt-1 relative">
        <div
          class="bg-white relative w-full border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 focus:ring-sky-900 focus:border-sky-900 focus:shadow-sky-900/50 focus:shadow-md "
          x-ref="button"
          tabindex="0"
          @keydown.enter.stop.prevent="onButtonClick()"
          @keydown.space.stop.prevent="onButtonClick()"
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
        </div>
        <div
          x-show="open"
          x-transition:leave="transition ease-in duration-100"
          x-transition:leave-start="opacity-100"
          x-transition:leave-end="opacity-0"
          class="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-md"
          @click.away="open = false"
          @keydown.enter.stop.prevent="onOptionSelect()"
          @keydown.space.stop.prevent="onOptionSelect()"
          @keydown.escape="onEscape()"
          @keydown.arrow-up.prevent="onArrowUp()"
          @keydown.arrow-down.prevent="onArrowDown()"
          @keydown.tab="onEscape()"
          x-ref="listbox"
          tabindex="-1"
          role="listbox"
          aria-labelledby={@label_id}
          :aria-activedescendant="activeDescendant"
          style="display: none;"
        >
          <%= for {%{value: value} = option, index} <- Enum.with_index(@options) do %>
            <.listbox_option
              option={option}
              index={index}
              option_id={"#{@input_id}-option-#{index}"}
              selected={value == @selected_value}
            />
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders the listbox element

  ## Options

    * `option` - The value field for the option
    * `index` - The index position in the option list
    * `selected` - Boolean indicating whether this option is selected
    * `option_id` - The DOM id to use for this option
  """
  def listbox_option(assigns) do
    assigns =
      assigns
      |> assign_new(:value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="option"
      @click={"choose(#{@index})"}
      @mouseenter={"activeIndex = #{@index}"}
      @mouseleave="activeIndex = null"
      data-value={@option.value}
      data-display={@option.display}
      class={"cursor-default select-none relative py-2 pl-3 pr-9 #{option_classes(@selected, "bg-sky-900/75")}"}
      :class={"{
        'text-white bg-sky-900/75': activeIndex === #{@index},
        'text-gray-900': !(activeIndex === #{@index})
      }"}
    >
      <div class="flex items-baseline">
        <span
          class={"#{text_classes(@selected)} block truncate"}
          :class={"{
            'font-semibold': selectedIndex === #{@index},
            'font-normal': !(selectedIndex === #{@index})
          }"}
        >
          <%= @display %>
        </span>
        <%= if @detail do %>
          <span
            class={"#{detail_classes(@selected)} ml-2 truncate text-sm"}
            :class={"{
              'text-sky-200': activeIndex === #{@index},
              'text-gray-500': !(activeIndex === #{@index})
            }"}
          >
            <%= @detail %>
          </span>
        <% end %>
      </div>

      <span
        x-show={"selectedIndex === #{@index}"}
        class={"absolute inset-y-0 right-0 flex items-center pr-4 #{checkbox_classes(@selected, "text-sky-900")}"}
        style={unless @selected, do: "display: none;"}
        :class={"{
          'text-white': activeIndex === #{@index},
          'text-sky-900': !(activeIndex === #{@index})
        }"}
      >
        <Heroicons.Solid.check class="h-5 w-5" />
      </span>
    </div>
    """
  end

  defp option_classes(selected, bg_color_class),
    do: if(selected, do: "text-white #{bg_color_class}", else: "text-gray-900")

  defp text_classes(selected), do: if(selected, do: "font-semibold", else: "font-normal")
  defp detail_classes(active), do: if(active, do: "text-indigo-200", else: "text-gray-500")

  defp checkbox_classes(selected, text_color_class),
    do: if(selected, do: "text-white", else: text_color_class)
end
