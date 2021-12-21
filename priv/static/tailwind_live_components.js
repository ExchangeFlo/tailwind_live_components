window.TailwindLiveComponents = {}

window.TailwindLiveComponents.telInput = function (e) {
  return {
    value: null,
    display: null,

    init() {
      this.value = this.scrubInput(this.$refs.valueInput.value)
      this.display = this.formatDisplay(this.value)
    },

    onValueChanged(event) {
      this.value = this.scrubInput(event.target.value)
      this.display = this.formatDisplay(this.value)
    },

    scrubInput(input) {
      return (input.replace(/\D/g, '').substring(0, 10).match(/^[2-9]{1}\d{0,9}$/) || [""])[0]
    },

    formatDisplay(input) {
      if (input === null) return "";

      const areaCode = input.substring(0, 3);
      const middle = input.substring(3, 6);
      const last = input.substring(6, 10);

      if (input.length > 6) {
        return `(${areaCode}) ${middle}-${last}`
      } else if (this.value.length > 3) {
        return `(${areaCode}) ${middle}`
      } else if (this.value.length > 0) {
        return `(${areaCode}`
      }

      return input
    }
  }
}

window.TailwindLiveComponents.listbox = function (e) {
  return {
    items: [],
    activeDescendant: null,
    optionCount: null,
    open: false,
    activeIndex: null,
    selectedIndex: null,
    prompt: null,

    init() {
      this.items = Array.from(this.$refs.listbox.children).map(item => item.dataset),
        this.optionCount = this.items.length,
        this.$watch("activeIndex", (e => {
          this.open && (null !== this.activeIndex ? this.activeDescendant = this.$refs.listbox.children[this.activeIndex].id : this.activeDescendant = "")
        }))
    },
    get selectedValue() {
      return null !== this.selectedIndex ? this.items[this.selectedIndex].value : null
    },
    get selectedDisplay() {
      return null !== this.selectedIndex ? this.items[this.selectedIndex].display : this.prompt
    },
    choose(e) {
      this.selectedIndex = e,
        this.open = false
    },
    onButtonClick() {
      if (this.open) {
        this.open = false
      } else {
        this.activeIndex = (this.selectedIndex || 0),
          this.open = true,
          setTimeout(() => {
            this.$refs.listbox.focus(),
              null !== this.activeIndex && this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
          }, 100)
      }
    },
    onOptionSelect() {
      null !== this.activeIndex && (this.selectedIndex = this.activeIndex), this.open = false, this.$refs.button.focus()
    },
    onEscape() {
      this.open = false, this.$refs.button.focus()
    },
    onArrowUp() {
      this.activeIndex = this.activeIndex === null || this.activeIndex - 1 < 0 ? this.optionCount - 1 : this.activeIndex - 1,
        this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
    },
    onArrowDown() {
      if (this.activeIndex === null) {
        this.activeIndex = 0,
          this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
      } else {
        this.activeIndex = this.activeIndex + 1 > this.optionCount - 1 ? 0 : this.activeIndex + 1,
          this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
      }
    },
    ...e
  }
}

window.TailwindLiveComponents.radioGroup = function (e) {
  return {
    options: [],
    optionCount: null,
    activeIndex: null,
    selectedIndex: null,

    init() {
      this.options = Array.from(this.$refs.radiogroup.children),
        this.optionCount = this.options.length

      for (let option of this.options)
        option.addEventListener("change", (() => {
          this.selectedIndex = parseInt(option.dataset.index)
        })),
          option.addEventListener("focus", (() => {
            this.activeIndex = parseInt(option.dataset.index)
          }))

      window.addEventListener("focus", (() => {
        this.options.includes(document.activeElement) || (this.activeIndex = null)
      }), true)
    },
    get value() {
      return null !== this.selectedIndex ? this.options[this.selectedIndex].dataset.value : null
    },
    choose(e) {
      this.selectedIndex = this.activeIndex = e
    },
    onArrowUp() {
      if (this.activeIndex === null) {
        this.activeIndex = 0
      } else {
        this.activeIndex = this.activeIndex - 1 < 0 ? this.optionCount - 1 : this.activeIndex - 1
      }

      this.options[this.activeIndex].focus()
    },
    onArrowDown() {
      if (this.activeIndex === null) {
        this.activeIndex = 0
      } else {
        this.activeIndex = this.activeIndex + 1 > this.optionCount - 1 ? 0 : this.activeIndex + 1
      }

      this.options[this.activeIndex].focus()
    }
  }
}
