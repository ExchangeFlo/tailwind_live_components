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
    * `detail` - Optional detail shown below the input
    * `prompt` - An option to include at the top of the options with the given prompt text
    * `options` - The options in the list box
    * `error` - Optional error message
    * `theme` - Optional theme to use for Tailwind classes
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
      |> assign_new(:detail, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

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
          class={"#{@theme.bg_color} relative w-full border #{@theme.border_color} rounded-md shadow-sm pl-3 pr-10 py-2 text-left sm:text-md cursor-default focus:outline-none focus:ring-1 focus:#{@theme.focus_ring_color} focus:#{@theme.focus_border_color} focus:shadow-md "}
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
            <Heroicons.Solid.selector class={"h-5 w-5 #{@theme.lighter_text_color}"} />
          </span>
        </div>
        <div
          x-show="open"
          x-transition:leave="transition ease-in duration-100"
          x-transition:leave-start="opacity-100"
          x-transition:leave-end="opacity-0"
          class={"absolute z-10 mt-1 w-full #{@theme.bg_color} shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-md"}
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
      @click={"choose(#{@index})"}
      @mouseenter={"activeIndex = #{@index}"}
      @mouseleave="activeIndex = null"
      data-value={@option.value}
      data-display={@option.display}
      class={"cursor-default select-none relative py-2 pl-3 pr-9 #{option_classes(@theme, @selected)}"}
      :class={"{
        '#{@theme.selected_text_color} #{@theme.selected_bg_color}': activeIndex === #{@index},
        '#{@theme.text_color}': !(activeIndex === #{@index})
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
            class={"#{detail_classes(@theme, @selected)} ml-2 truncate text-sm"}
            :class={"{
              '#{@theme.selected_light_text_color}': activeIndex === #{@index},
              '#{@theme.light_text_color}': !(activeIndex === #{@index})
            }"}
          >
            <%= @detail %>
          </span>
        <% end %>
      </div>

      <span
        x-show={"selectedIndex === #{@index}"}
        class={"absolute inset-y-0 right-0 flex items-center pr-4 #{checkbox_classes(@theme, @selected)}"}
        style={unless @selected, do: "display: none;"}
        :class={"{
          '#{@theme.selected_text_color}': activeIndex === #{@index},
          '#{@theme.selected_highlight_text_color}': !(activeIndex === #{@index})
        }"}
      >
        <Heroicons.Solid.check class="h-5 w-5" />
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

  defp option_classes(theme, selected), do: if(selected, do: "#{theme.selected_text_color} #{theme.selected_bg_color}", else: theme.text_color)

  defp detail_classes(theme, active), do: if(active, do: theme.selected_light_text_color, else: theme.light_text_color)

  defp checkbox_classes(theme, selected), do: if(selected, do: theme.selected_text_color, else: theme.selected_highlight_text_color)

  defp text_classes(selected), do: if(selected, do: "font-semibold", else: "font-normal")
end
