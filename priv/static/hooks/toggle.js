export default {
  $valueInput: null,
  $toggleInput: null,
  on: false,

  mounted() {
    this.$valueInput = this.el.querySelector('[tlc-ref="valueInput"]')
    this.$toggleInput = this.el.querySelector('[tlc-ref="toggleInput"]')
    this.$toggleInput.addEventListener("click", () => this.toggle())

    this.$toggleInput.addEventListener("keydown", (event) => {
      if (event.code == "Enter" || event.code == "Space") {
        event.preventDefault()
        this.toggle()
      }
    })

    this.value = this.$valueInput.value == "true"
  },

  toggle() {
    this.on = !this.on
    this.$valueInput.value = this.on.toString()
    this.$toggleInput.setAttribute('aria-checked', this.on.toString())

    if (this.on) {
      document.querySelectorAll(`[data-toggle-on]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-toggle-on"))
      })
    } else {
      document.querySelectorAll(`[data-toggle-off]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-toggle-off"))
      })
    }
  }
}
