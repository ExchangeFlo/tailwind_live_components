export default {
  $valueInput: null,

  mounted() {
    liveSocket.execJS(this.el, this.el.dataset.show)
  },
}
