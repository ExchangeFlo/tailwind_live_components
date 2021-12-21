defmodule TailwindLiveComponents.VerticalRadioGroup do
  use Phoenix.Component

  @moduledoc """

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
  def radio_group(assigns) do
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
      x-data={"TailwindLiveComponents.radioGroup({
        selectedIndex: #{@selected_index || "null"}
      })"}
      x-init="init()"
      role="radiogroup"
      aria-labelledby={@label_id}
    >
      <%= Phoenix.HTML.Form.hidden_input(@form, @field, id: @input_id, "x-model": "value") %>

      <label id={@label_id} class="block text-md font-medium text-gray-700">
        <%= @label %>
      </label>
      <div
        class="space-y-2"
        role="none"
        x-ref="radiogroup"
      >
        <%= for {option, index} <- Enum.with_index(@options) do %>
          <.radio
            option={option}
            index={index}
            option_id={"#{@input_id}-option-#{index}"}
          />
        <% end %>
      </div>
    </div>
    """
  end

  def radio(assigns) do
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
      class="relative flex px-5 py-4 rounded-lg shadow-sm cursor-pointer focus:outline-none border focus:ring-1 focus:ring-sky-900 focus:border-sky-900 focus:shadow-md"
      :class={"{
        'bg-sky-900/75 focus:shadow-sky-900/50 border-transparent ': selectedIndex === #{@index},
        'bg-white border-gray-300': !(selectedIndex === #{@index})
      }"}

    >
      <div class="flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="text-md">
            <p
              id={@label_id}
              class="font-medium"
              :class={"{
                'text-white': selectedIndex === #{@index},
                'text-gray-900': !(selectedIndex === #{@index})
              }"}
            >
              <%= @display %>
            </p>
            <%= if @detail do %>
              <span
                id={@description_id}
                class="inline text-sm"
                :class={"{
                  'text-sky-200': selectedIndex === #{@index},
                  'text-gray-500': !(selectedIndex === #{@index})
                }"}
              >
                <span><%= @detail %></span>
              </span>
            <% end %>
          </div>
        </div>
        <div
          x-show={"selectedIndex === #{@index}"}
          class="flex-shrink-0 text-white"
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
end
