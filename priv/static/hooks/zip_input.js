export default {
  $valueInput: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[data-tlc-ref="valueInput"]')
    this.$valueInput.addEventListener("input", (event) => {
      this.$valueInput.value = this.scrubInput(event.target.value)
    })

    this.scrubInput(this.$valueInput.value)
  },

  scrubInput(input) {
    return input.replace(/\D/g, '').substring(0, 5).match(/^\d{0,9}$/)
  }
}
