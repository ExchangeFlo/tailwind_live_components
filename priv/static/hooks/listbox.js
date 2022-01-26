export default {
  $valueInput: null,
  $button: null,
  $selectedText: null,
  $listbox: null,
  $options: [],
  open: false,
  optionCount: 0,
  activeIndex: 0,
  selectedIndex: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[data-tlc-ref="valueInput"]')

    this.$button = this.el.querySelector('[data-tlc-ref="button"]')
    this.$button.addEventListener("click", () => this.toggleListbox()),
      this.$button.addEventListener("keydown", (event) => {
        if (event.code == "Enter" || event.code == "Space" || event.code == "ArrowUp" || event.code == "ArrowDown") {
          event.preventDefault()

          this.toggleListbox()
        }
      })

    this.$selectedText = this.el.querySelector('[data-tlc-ref="selectedText"]')

    this.$listbox = this.el.querySelector('[data-tlc-ref="listbox"]')
    this.$listbox.addEventListener("blur", () => { this.closeListbox() })
    this.$listbox.addEventListener("keydown", (event) => {
      if (event.code == "Enter" || event.code == "Space") {
        event.preventDefault()
        this.chooseOption(this.activeIndex)
      } else if (event.code == "Escape" || event.code == "Tab") {
        event.preventDefault()
        this.closeListbox()
      } else if (event.code == "ArrowUp") {
        event.preventDefault()
        this.setActive(this.activeIndex - 1 < 0 ? this.optionCount - 1 : this.activeIndex - 1)
      } else if (event.code == "ArrowDown") {
        event.preventDefault()
        this.setActive(this.activeIndex + 1 > this.optionCount - 1 ? 0 : this.activeIndex + 1)
      }
    })

    this.$options = Array.from(this.$listbox.children)
    this.$options.forEach(($option, index) => {
      $option.addEventListener("mouseenter", () => this.setActive(index)),
        $option.addEventListener("click", () => this.chooseOption(index))
    })

    this.optionCount = this.$options.length

    let selectedValue = this.$valueInput.value
    let selectedValueIndex = this.$options.findIndex((option) => option.value == selectedValue)
    if (selectedValueIndex >= 0) {
      this.setActive(selectedValueIndex),
        this.setSelected(selectedValueIndex)
    } else {
      this.setActive(0),
        this.setSelected(null)
    }
  },

  toggleListbox() {
    if (this.open) {
      this.closeListbox()
    } else {
      this.openListbox()
    }
  },

  openListbox() {
    this.open = true,
      liveSocket.execJS(this.$listbox, this.$listbox.getAttribute("data-listbox-open")),
      this.$button.setAttribute('aria-expanded', this.open.toString()),
      this.open = true,
      setTimeout(() => {
        this.$listbox.focus(),
          this.setActive(this.activeIndex)
      }, 100)
  },

  closeListbox() {
    this.open = false,
      this.$button.setAttribute('aria-expanded', this.open.toString()),
      this.$button.focus(),
      liveSocket.execJS(this.$listbox, this.$listbox.getAttribute("data-listbox-close"))
  },

  setActive(index) {
    // de-select the current active option
    if (this.activeIndex !== index) {
      let option = this.$options[this.activeIndex]

      liveSocket.execJS(option, option.getAttribute("data-listbox-option-inactive")),
        option.querySelectorAll(`[data-listbox-option-inactive]`).forEach(el => {
          liveSocket.execJS(el, el.getAttribute("data-listbox-option-inactive"))
        })
    }

    // select the new active option
    let $option = this.$options[index]

    liveSocket.execJS($option, $option.getAttribute("data-listbox-option-active")),
      $option.querySelectorAll(`[data-listbox-option-active]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-listbox-option-active"))
      }),
      $option.scrollIntoView({ block: "nearest" }),
      this.$listbox.setAttribute('aria-activedescendant', $option.id)

    this.activeIndex = index
  },

  setSelected(index) {
    // de-select the current selected option
    if (this.selectedIndex !== null) {
      let option = this.$options[this.selectedIndex]

      option.querySelectorAll(`[data-listbox-option-not-selected]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-listbox-option-not-selected"))
      })
    }

    // select the new selected option
    if (index !== null) {
      let $option = this.$options[index]

      $option.querySelectorAll(`[data-listbox-option-selected]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-listbox-option-selected"))
      })

      this.$selectedText.innerText = $option.dataset.display
      this.$valueInput.value = $option.dataset.value
      this.$valueInput.dispatchEvent(new CustomEvent('change', { bubbles: true }));
    } else {
      this.$selectedText.innerText = '\xa0'
      this.$valueInput.value = null
    }

    this.selectedIndex = index
  },

  chooseOption(index) {
    this.setSelected(index),
      this.closeListbox()
  },
}
