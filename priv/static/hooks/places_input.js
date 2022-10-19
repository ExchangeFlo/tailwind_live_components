export default {
  $valueInput: null,
  apiKey: null,
  latitude: null,
  longitude: null,
  countryCode: null,

  mounted() {
    this.$valueInput = this.el.querySelector('[data-tlc-ref="valueInput"]')
    this.$addressInput = this.el.dataset.addressInputId ? document.querySelector('#' + this.el.dataset.addressInputId) : null
    this.$cityInput = this.el.dataset.cityInputId ? document.querySelector('#' + this.el.dataset.cityInputId) : null
    this.$stateInput = this.el.dataset.stateInputId ? document.querySelector('#' + this.el.dataset.stateInputId) : null
    this.$zipInput = this.el.dataset.zipInputId ? document.querySelector('#' + this.el.dataset.zipInputId) : null
    this.apiKey = this.el.dataset.apiKey
    this.latitude = this.el.dataset.latitude
    this.longitude = this.el.dataset.longitude
    this.countryCode = this.el.dataset.countryCode

    window.initAutocomplete = () => {
      const center = {
        lat: parseFloat(this.latitude),
        lng: parseFloat(this.longitude)
      }

      const autocomplete = new google.maps.places.Autocomplete(this.$valueInput, {
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

      google.maps.event.addDomListener(this.$valueInput, 'keydown', function (event) {
        if (event.keyCode === 13) {
          event.preventDefault()
        }
      })

      autocomplete.addListener("place_changed", () => {
        const place = autocomplete.getPlace()

        let addressValue = ""
        let cityValue = ""
        let stateValue = ""
        let zipValue = ""

        for (const component of place.address_components) {
          const componentType = component.types[0]

          switch (componentType) {
            case "street_number":
              addressValue = `${component.long_name} ${addressValue}`
              break

            case "route":
              addressValue += component.short_name
              break

            case "locality":
              cityValue = component.long_name
              break

            case "administrative_area_level_1":
              stateValue = component.short_name
              break

            case "postal_code":
              zipValue = component.short_name
              break
          }
        }

        if (this.$addressInput && addressValue) this.$addressInput.value = addressValue
        if (this.$cityInput && cityValue) this.$cityInput.value = cityValue
        if (this.$stateInput && stateValue) this.$stateInput.value = stateValue
        if (this.$zipInput && zipValue) this.$zipInput.value = zipValue
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
