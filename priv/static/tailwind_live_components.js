window.TailwindLiveComponents = {}

window.TailwindLiveComponents.listbox = function (e) {
  return {
    init() {
      this.items = Array.from(this.$refs.listbox.children).map(item => item.dataset),
        this.optionCount = this.items.length,
        this.$watch("activeIndex", (e => {
          this.open && (null !== this.activeIndex ? this.activeDescendant = this.$refs.listbox.children[this.activeIndex].id : this.activeDescendant = "")
        }))
    },
    items: [],
    activeDescendant: null,
    optionCount: null,
    open: false,
    activeIndex: null,
    selectedIndex: null,
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
