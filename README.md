# TailwindLiveComponents

Set of Elixir LiveView Components for building forms with Tailwind CSS.

- requires TailwindCSS 2.0+

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tailwind_live_components` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tailwind_live_components, "~> 0.1.0"}
  ]
end
```

Import the `tailwind_live_components` javascript dependency to `app.js`.
This is included in the hex package that's installed in the `deps`

```javascript
import "tailwind_live_components"
```

Update your `tailwind.config.js` file to include the `tailwind_live_components`
folder so all styles used there will be captured by the JIT complier:

```js
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
    
    // Add new folder to monitor
    '../deps/tailwind_live_components/**/*.*ex'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tailwind_live_components>.

