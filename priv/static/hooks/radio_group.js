export default {
  $valueInput: null,
  $radiogroup: null,
  $options: [],
  optionCount: 0,
  activeIndex: 0,
  selectedIndex: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[data-tlc-ref="valueInput"]')
    this.$radiogroup = this.el.querySelector('[data-tlc-ref="radiogroup"]')

    this.$options = Array.from(this.$radiogroup.children)
    this.$options.forEach(($option, index) => {
      $option.addEventListener("mouseenter", () => this.setActive(index)),
        $option.addEventListener("click", () => this.setSelected(index)),
        $option.addEventListener("keydown", (event) => {
          if (event.code == "Enter" || event.code == "Space") {
            event.preventDefault()
            this.setSelected(index)
          } else if (event.code == "ArrowUp" || event.code == "ArrowLeft") {
            event.preventDefault()
            this.setActive(this.activeIndex - 1 < 0 ? this.optionCount - 1 : this.activeIndex - 1)
          } else if (event.code == "ArrowDown" || event.code == "ArrowRight") {
            event.preventDefault()
            this.setActive(this.activeIndex + 1 > this.optionCount - 1 ? 0 : this.activeIndex + 1)
          }
        })
    })

    this.optionCount = this.$options.length
  },

  setActive(index) {
    this.$options[index].focus()

    this.activeIndex = index
  },

  setSelected(index) {
    // de-select the current selected option
    if (this.selectedIndex !== null) {
      let $option = this.$options[this.selectedIndex]

      $option.setAttribute('aria-checked', "false"),
        liveSocket.execJS($option, $option.getAttribute("data-radiogroup-option-not-selected")),
        $option.querySelectorAll(`[data-radiogroup-option-not-selected]`).forEach(el => {
          liveSocket.execJS(el, el.getAttribute("data-radiogroup-option-not-selected"))
        })
    }

    // select the new selected option
    if (index !== null) {
      let $option = this.$options[index]

      $option.setAttribute('aria-checked', "true"),
        liveSocket.execJS($option, $option.getAttribute("data-radiogroup-option-selected")),
        $option.querySelectorAll(`[data-radiogroup-option-selected]`).forEach(el => {
          liveSocket.execJS(el, el.getAttribute("data-radiogroup-option-selected"))
        })

      this.$valueInput.value = $option.dataset.value
      this.$valueInput.dispatchEvent(new CustomEvent('change', { bubbles: true }));
    }

    this.selectedIndex = index
  }
}
