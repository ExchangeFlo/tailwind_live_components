export default {
  $valueInput: null,
  $bar: null,
  $thumb: null,
  $display: null,
  value: null,
  min: null,
  max: null,
  step: null,
  active: false,

  mounted() {
    this.$valueInput = this.el.querySelector('[tlc-ref="valueInput"]')
    this.$display = this.el.querySelector('[tlc-ref="display"]')
    this.$bar = this.el.querySelector('[tlc-ref="bar"]')
    this.$thumb = this.el.querySelector('[tlc-ref="thumb"]')

    this.value = parseInt(this.$valueInput.value)
    this.min = parseInt(this.$valueInput.min)
    this.max = parseInt(this.$valueInput.max)
    this.step = parseInt(this.$valueInput.step)

    this.$valueInput.addEventListener("focus", () => this.setActive(true))
    this.$valueInput.addEventListener("blur", () => this.setActive(false))
    this.$valueInput.addEventListener("input", (event) => this.handleInput(event.target.value))

    let active = this.$valueInput === document.activeElement
    this.setActive(active)
  },

  setActive(active) {
    this.active = active

    if (active) {
      this.el.querySelectorAll(`[data-active]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-active"))
      })
    } else {
      this.el.querySelectorAll(`[data-inactive]`).forEach(el => {
        liveSocket.execJS(el, el.getAttribute("data-inactive"))
      })
    }
  },

  handleInput(value) {
    this.$valueInput.setAttribute("value", value)
    this.$valueInput.setAttribute("aria-valuenow", value)

    let thumbPosition = ((value - this.min) / (this.max - this.min)) * 96
    this.$display.innerText = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    this.$bar.style = `left:${thumbPosition}%; right:0%`
    this.$thumb.style = `left:${thumbPosition}%`
  }
}
