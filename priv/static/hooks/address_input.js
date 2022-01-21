export default {
  $valueInput: null,
  apiKey: null,
  latitude: null,
  longitude: null,
  countryCode: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[data-tlc-ref="valueInput"]')
    this.apiKey = this.el.dataset.apiKey
    this.latitude = this.el.dataset.latitude
    this.longitude = this.el.dataset.longitude
    this.countryCode = this.el.dataset.countryCode

    window.initAutocomplete = () => {
      const center = {
        lat: parseFloat(this.latitude),
        lng: parseFloat(this.longitude)
      };

      new google.maps.places.Autocomplete(this.$valueInput, {
        // Create a bounding box with sides ~10km away from the center point
        bounds: {
          north: center.lat + 0.1,
          south: center.lat - 0.1,
          east: center.lng + 0.1,
          west: center.lng - 0.1,
        },
        componentRestrictions: { country: this.countryCode },
        fields: ["address_components"],
        strictBounds: false,
        types: ["address"],
      })
    }

    this.loadGooglePlaces()
  },

  loadGooglePlaces(d, s) {
    js = document.createElement('script')
    js.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKey}&libraries=places&callback=initAutocomplete`
    this.$valueInput.parentNode.insertBefore(js, this.$valueInput)
  },
}
