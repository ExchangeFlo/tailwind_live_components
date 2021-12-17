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
    selectedIndex: 0,
    get active() {
      return this.items[this.activeIndex]
    },
    get selected() {
      return this.items[this.selectedIndex]
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
            this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
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
      this.activeIndex = this.activeIndex - 1 < 0 ? this.optionCount - 1 : this.activeIndex - 1,
        this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
    },
    onArrowDown() {
      this.activeIndex = this.activeIndex + 1 > this.optionCount - 1 ? 0 : this.activeIndex + 1,
        this.$refs.listbox.children[this.activeIndex].scrollIntoView({ block: "nearest" })
    },
    ...e
  }
}

