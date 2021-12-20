defmodule TailwindLiveComponents.HorizontalRadioGroup do
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
        class={"mt-2 grid grid-cols-1 gap-y-2 #{grid_columns(@options)} sm:gap-x-2"}
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
      @keydown.arrow-left.prevent="onArrowUp()"
      @keydown.arrow-right.prevent="onArrowDown()"
      class="relative flex px-5 py-4 rounded-lg shadow-md cursor-pointer focus:outline-none bg-white border border-gray-300 focus:ring-1 focus:ring-sky-900 focus:border-sky-900"
      :class={"{
        'bg-sky-900/75 border-transparent': selectedIndex === #{@index},
        'bg-white': !(selectedIndex === #{@index})
      }"}

    >
      <div class="flex justify-between w-full">
        <div class="flex-1 flex">
          <div class="flex flex-col">
            <span
              id={@label_id}
              class="font-medium text-md"
              :class={"{
                'text-white': selectedIndex === #{@index},
                'text-gray-900': !(selectedIndex === #{@index})
              }"}
            >
              <%= @display %>
            </span>
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
