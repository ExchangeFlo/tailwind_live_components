import LabelError from "./hooks/label_error"
import Listbox from "./hooks/listbox"
import RadioGroup from "./hooks/radio_group"
import Slider from "./hooks/slider"
import TelInput from "./hooks/tel_input"
import Toggle from "./hooks/toggle"
import ZipInput from "./hooks/zip_input"
import PlacesInput from "./hooks/places_input"

let Hooks = {}
Hooks.tlcLabelError = LabelError
Hooks.tlcListbox = Listbox
Hooks.tlcRadioGroup = RadioGroup
Hooks.tlcSlider = Slider
Hooks.tlcTelInput = TelInput
Hooks.tlcToggle = Toggle
Hooks.tlcZipInput = ZipInput
Hooks.tlcPlacesInput = PlacesInput

export default Hooks
