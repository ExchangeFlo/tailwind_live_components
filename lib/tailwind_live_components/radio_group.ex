defmodule TailwindLiveComponents.RadioGroup do
  use Phoenix.Component

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
    assigns = assign_new(assigns, :orientation, fn -> "vertical" end)

    ~H"""
      <%= if @orientation == "horizontal" do %>
        <.horizontal_radio_group {assigns} />
      <% else %>
        <.vertical_radio_group {assigns} />
      <% end %>
    """
  end

  def vertical_radio_group(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    prompt = Map.get(assigns, :prompt, Phoenix.HTML.raw("&nbsp;"))
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
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div
      x-data={"TailwindLiveComponents.radioGroup({
        selectedIndex: #{@selected_index || "null"}
      })"}
      x-init="init()"
      role="radiogroup"
      aria-labelledby={@label_id}
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "value") %>

      <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

      <div
        class="mt-1 space-y-2"
        role="none"
        x-ref="radiogroup"
      >
        <%= for {option, index} <- Enum.with_index(@options) do %>
          <.vertical_radio_option
            option={option}
            index={index}
            option_id={"#{@input_id}-option-#{index}"}
            theme={@theme}
          />
        <% end %>
      </div>
    </div>
    """
  end

  defp vertical_radio_option(assigns) do
    assigns =
      assigns
      |> assign_new(:label_id, fn -> assigns.option_id <> "-label" end)
      |> assign_new(:description_id, fn -> assigns.option_id <> "-description" end)
      |> assign_new(:value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="radio"
      :aria-checked={"selectedIndex == #{@index}"}
      tabindex="0"
      aria-labelledby={@label_id}
      aria-describedby={@description_id}
      data-index={@index}
      data-value={@value}
      @click={"choose(#{@index})"}
      @keydown.enter.prevent={"choose(#{@index})"}
      @keydown.space.prevent={"choose(#{@index})"}
      @keydown.arrow-up.prevent="onArrowUp()"
      @keydown.arrow-down.prevent="onArrowDown()"
      class={"relative flex px-5 py-4 rounded-lg shadow-sm cursor-pointer focus:outline-none border focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md"}
      :class={"{
        '#{@theme.selected_bg_color} #{@theme.focus_selected_shadow_color} #{@theme.selected_border_color}': selectedIndex === #{@index},
        '#{@theme.bg_color} #{@theme.border_color}': !(selectedIndex === #{@index})
      }"}

    >
      <div class="flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="text-md">
            <p
              id={@label_id}
              class="font-medium"
              :class={"{
                '#{@theme.selected_text_color}': selectedIndex === #{@index},
                '#{@theme.text_color}': !(selectedIndex === #{@index})
              }"}
            >
              <%= @display %>
            </p>
            <%= if @detail do %>
              <span
                id={@description_id}
                class="inline text-sm"
                :class={"{
                  '#{@theme.selected_light_text_color}': selectedIndex === #{@index},
                  '#{@theme.light_text_color}': !(selectedIndex === #{@index})
                }"}
              >
                <span><%= @detail %></span>
              </span>
            <% end %>
          </div>
        </div>
        <div
          x-show={"selectedIndex === #{@index}"}
          class={"flex-shrink-0 #{@theme.selected_text_color}"}
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

  defp horizontal_radio_group(assigns) do
    input_id = Phoenix.HTML.Form.input_id(assigns.form, assigns.field)
    label_id = input_id <> "-label"

    prompt = Map.get(assigns, :prompt, Phoenix.HTML.raw("&nbsp;"))
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
      |> assign_new(:label_id, fn -> label_id end)
      |> assign_new(:error, fn -> nil end)
      |> assign_new(:theme, fn -> %TailwindLiveComponents.Theme{} end)

    ~H"""
    <div
      x-data={"TailwindLiveComponents.radioGroup({
        selectedIndex: #{@selected_index || "null"}
      })"}
      x-init="init()"
      role="radiogroup"
      aria-labelledby={@label_id}
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "value") %>

      <Label.label form={@form} field={@field} label={@label} input_id={@input_id} label_id={@label_id} error={@error} />

      <div
        class={"mt-1 grid grid-cols-1 gap-y-2 #{grid_columns(@options)} sm:gap-x-2"}
        role="none"
        x-ref="radiogroup"
      >
        <%= for {option, index} <- Enum.with_index(@options) do %>
          <.horizontal_radio_option
            option={option}
            index={index}
            option_id={"#{@input_id}-option-#{index}"}
            theme={@theme}
          />
        <% end %>
      </div>
    </div>
    """
  end

  defp horizontal_radio_option(assigns) do
    assigns =
      assigns
      |> assign_new(:label_id, fn -> assigns.option_id <> "-label" end)
      |> assign_new(:description_id, fn -> assigns.option_id <> "-description" end)
      |> assign_new(:value, fn -> Map.get(assigns.option, :value) end)
      |> assign_new(:display, fn -> Map.get(assigns.option, :display) end)
      |> assign_new(:detail, fn -> Map.get(assigns.option, :detail) end)

    ~H"""
    <div
      id={@option_id}
      role="radio"
      :aria-checked={"selectedIndex == #{@index}"}
      tabindex="0"
      aria-labelledby={@label_id}
      aria-describedby={@description_id}
      data-index={@index}
      data-value={@value}
      @click={"choose(#{@index})"}
      @keydown.enter.prevent={"choose(#{@index})"}
      @keydown.space.prevent={"choose(#{@index})"}
      @keydown.arrow-left.prevent="onArrowUp()"
      @keydown.arrow-right.prevent="onArrowDown()"
      class={"relative flex px-5 py-4 rounded-lg shadow-sm cursor-pointer focus:outline-none border focus:ring-1 #{@theme.focus_ring_color} #{@theme.focus_border_color} focus:shadow-md"}
      :class={"{
        '#{@theme.selected_bg_color} #{@theme.focus_selected_shadow_color} #{@theme.selected_border_color}': selectedIndex === #{@index},
        '#{@theme.bg_color} #{@theme.border_color}': !(selectedIndex === #{@index})
      }"}

    >
      <div class="flex justify-between w-full">
        <div class="flex-1 flex">
          <div class="flex flex-col">
            <span
              id={@label_id}
              class="font-medium text-md"
              :class={"{
                '#{@theme.selected_text_color}': selectedIndex === #{@index},
                '#{@theme.text_color}': !(selectedIndex === #{@index})
              }"}
            >
              <%= @display %>
            </span>
            <%= if @detail do %>
              <span
                id={@description_id}
                class="inline text-sm"
                :class={"{
                  '#{@theme.selected_light_text_color}': selectedIndex === #{@index},
                  '#{@theme.light_text_color}': !(selectedIndex === #{@index})
                }"}
              >
                <span><%= @detail %></span>
              </span>
            <% end %>
          </div>
        </div>
        <svg
          viewBox="0 0 24 24"
          fill="none"
          class="w-6 h-6"
          :class={"{
            'invisible': !(selectedIndex === #{@index})
          }"}
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
end
