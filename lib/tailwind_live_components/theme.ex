defmodule TailwindLiveComponents.Theme do
  defstruct [
    # standard colors
    bg_color: "bg-white",
    light_bg_color: "bg-gray-200",
    border_color: "border-gray-300",
    shadow_color: "",
    text_color: "text-gray-900",
    light_text_color: "text-gray-500",
    lighter_text_color: "text-gray-300",
    error_text_color: "text-red-500",

    # selected colors
    selected_bg_color: "bg-sky-900/75",
    selected_border_color: "border-transparent",
    selected_shadow_color: "shadow-sky-900/50",
    selected_text_color: "text-white",
    selected_light_text_color: "text-sky-200",
    selected_highlight_text_color: "text-sky-900",

    # focus colors
    focus_bg_color: "bg-sky-900",
    focus_ring_color: "ring-sky-900",
    focus_border_color: "border-sky-900"
  ]
end
