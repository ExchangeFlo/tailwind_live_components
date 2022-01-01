export default {
  $valueInput: null,
  $displayInput: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[tlc-ref="valueInput"]')
    this.$displayInput = this.el.querySelector('[tlc-ref="displayInput"]')
    this.$displayInput.addEventListener("input", (event) => {
      this.handleInput(event.target.value)
    })

    this.handleInput(this.$valueInput.value)
  },

  handleInput(input) {
    let value = this.scrubInput(input)

    this.$valueInput.value = value,
      this.$displayInput.value = this.formatDisplay(value)
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
    } else if (input.length > 3) {
      return `(${areaCode}) ${middle}`
    } else if (input.length > 0) {
      return `(${areaCode}`
    }

    return input
  },
}
