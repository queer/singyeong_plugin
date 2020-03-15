# 신경 plugin

A library that provides the plugin API for [신경](https://github.com/queer/singyeong).
This library is not useful on its own, and must be used alongside a 신경 instance.

An example plugin can be found here: https://github.com/queer/singyeong-test-plugin

## Installation

[Get it on Hex.](https://hex.pm/packages/singyeong_plugin)

```elixir
def deps do
  [
    {:singyeong_plugin, "~> 0.1.0"}
  ]
end
```

## Creating a plugin

Simply implement the `Singyeong.Plugin` behaviour in your plugin module. An
example of how to do this can be found here:
https://github.com/queer/singyeong-test-plugin/blob/master/lib/singyeong_plugin_test.ex

Once your plugin is ready, run the following commands:
```
$ mix compile
$ mix singyeong.package
```
and a zip file containing your plugin will be created. To use the plugin you
created, simply create a `plugins/` directory at your 신경 instance's root
directory, and copy the plugin zip into that directory.

## Native code

신경 plugins officially support NIFs implemented with [Rustler](https://github.com/rusterlium/rustler).
Other NIF libraries are unsupported and may break at any time, or simply never
work. 

Note that Rustler-based NIFs require some extra steps to be properly
신경-compatible:

1. Your NIF module should have `use Singyeong.Plugin.Rustler, crate: "crate_name"`
   instead of `use Rustler, otp_app: :my_app, crate: "crate_name"`.
2. That's it! (Note: this may change in the future)

## `.gitignore`

The following files should be added to your `.gitignore`:

- /work
- /*.zip

If using (Rustler) natives:

- /priv/native
- /native/*/target
- /native/*/.cargo