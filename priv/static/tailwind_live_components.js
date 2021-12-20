window.TailwindLiveComponents = {}

window.TailwindLiveComponents.listbox = function (e) {
  return {
    items: [],
    activeDescendant: null,
    optionCount: null,
    open: false,
    activeIndex: null,
    selectedIndex: null,

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
      return null !== this.selectedIndex ? this.items[this.selectedIndex].display : null
    },
    choose(e) {
      this.selectedIndex = e,
        this.open = false
    },
    onButtonClick() {
      this.open || (
        this.activeIndex = this.selectedIndex,
        this.open = true,
        this.$nextTick((() => {
          this.$refs.listbox.focus(),
            null !== this.activeIndex && this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
        }))
      )
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
        console.log("Focus change"),
          this.options.includes(document.activeElement) || (console.log("HIT"), this.activeIndex = null)
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
