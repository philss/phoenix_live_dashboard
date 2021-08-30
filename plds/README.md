# PLDS - Phoenix Live Dashboard Standalone

This application is a bundle of Phoenix Live Dashboard with some tools
preconfigured. This is meant to be used in environments where you don't
want to install the dashboard, or you can't install due to limitations.

It's a perfect fit for when you can access your system remotely, using
the distribution feature.

## Usage

You can install PLDS using the `mix escript.install hex plds`.
Make sure the path used for installing escripts are available in your
`PATH` variable in your terminal.

After that, you can start PLDS with the following command:

    $ plds server

The dashboard will open a page in your browser.
Check the options available by typing `plds --help`.

## Tools available

In this bundle it's available:
- Ecto with extras.
- Broadway with Broadway Dashboard.

## Contributing

Please see the [Contributing section](https://github.com/phoenixframework/phoenix_live_dashboard#contributing)
for Phoenix Live Dashboard.

## License

MIT License. Copyright (c) 2019 Michael Crumm, Chris McCord, José Valim.
