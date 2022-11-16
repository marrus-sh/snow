#  SNOW  #

A client-side frontend for Mastodon, a free & open-source social network server.

Current version: [*0.1.0*](CHANGELOG.md)

 - - -
 
##  Compatibility  ##

Snow inherits all of the requirements of Laboratory; ie, it requires full support ECMAScript 5.

Snow is designed to be usable with plugins; to prevent conflicting with other plugins' styles and elements, every Snow class name and id begins with the emoji `🌨`.
Snow also occasionally sets `data-snow-*` attributes on its own elements, including the element you pass through as root.
Snow ignores any element outside of the Snow root, including in its styles, and should generally be compatible with whatever additional styles you might implement.

Note that Snow uses relative sizing based on the `rem` unit in its various styles.

 - - -

##  Installing  ##

There are a couple of different ways you might want to install Snow.
Snow is entirely client-side, which means that it can be operated from even something so minimal as a GitHub Pages site.
However, it is possible to configure Snow as the default frontend for a Mastodon server as well.

###  Installation methods:

####  "Unhosted" install.

In the case of an unhosted (aka, not on a Mastodon server) install, you will want to *ignore* the root `index.js` and `index.scss` files and base your installation around `index.html`, which should work out-of-the box.
Modifying this file will allow you to fine-tune your configuration (see below).

####  Hosted install.

If you are hosting Snow on a Mastodon server, then the files `index.js` and `index.scss` will help you deploy the script.
However, until Mastodon gets proper frontend support we will have to do some hacking to get it to recognize these files.

#####  DEPENDENCIES

Snow depends on [Laboratory](https://github.com/marrus-sh/laboratory), version 0.5 or later.
A compatible minified version of Laboratory is provided in the `vendor/` folder, but you are free to substitute your own if you have specific requirements.

You should have a file in `/app/assets/stylesheets/` named `variables.scss`; you can use this to customize Snow's appearance.
Be sure to create this file if it doesn't already exist, as Snow expects it to be present.
Snow does not include any font files itself, so be sure to provide these if you want custom fonts to be supported.

#####  PROCEDURE

The recommended procedure for installing Snow on a Mastodon server is as follows:

1.  Include this folder in `/app/assets/frontends` (feel free to create this folder if it doesn't exist).
    You could feasibly include it somewhere else in the `assets` directory (for example, `/app/assets/javascripts`), but as this package contains both scripts and stylesheets the `frontends` folder is recommended.

2.  In the file `/app/views/home/index.html.haml`:

    -   Change the line `= javascript_include_tag 'application'` to instead read `= javascript_include_tag 'snow'`.

    -   Add the line `= stylesheet_link_tag 'snow', media: 'all'` to the `:header_tags` declaration.

    -   Remove the line `= react_component 'Mastodon', default_props, class: 'app-holder', prerender: false`.

    -   Optionally, add the line `#frontend` in the location that you want the frontend to render. If this is not specified then the frontend will render in the `<body>` element, which React doesn't recommend.

3.  Add the following line to `/config/initializers/assets.rb`:

    ```ruby
    Rails.application.config.assets.precompile += %w(snow.css snow.js)
    ```

    This will ensure that Snow's assets are properly precompiled.

4.  Add the conditional `if controller_name != 'home'` at the end of the line `= stylesheet_link_tag('application', media: 'all')` in `/app/views/layouts/application.html.haml`.
    This will disable the default Mastodon frontend styles, which would otherwise conflict with our own.

5.  Restart your server.

 - - -

##  Configuration  ##

There are two ways which you can configure Snow beyond the initial installation.
The first, recommended method is by including a JSON configuration object in a `<script id="snow-config" type="application/json">` element somewhere in the document.
The second method is by including a script which provides configuration details to `window.INITIAL_STATE`.
**Use of `window.INITIAL_STATE` is strongly discouraged for "unhosted" installs and is only supported to minimize the amount of configuration necessary for installations on a Mastodon server.**

The configuration options supported by Snow are as follows:

###  General configuration:

| Property | INITIAL_STATE equivalent | Description |
| -------- | ------------------------ | :---------- |
| `title` | `meta.title` | The title for the frontend. If you are hosting this on a Mastodon server, you might want to set this to the name of the server. Otherwise, it will default to "Snow Web Client" |
| `display` | *Not supported* | Display modes (see below). |
| `basename` | `meta.router_basename` | The base pathname for the frontend. For example, a Snow frontend hosted at `http://example.org/gateway` would use the basename `/gateway`. This defaults to `/web` for compatibility reasons. |
| `locale` | `meta.locale` | The locale for the frontend. |
| `root` | `meta.react_root` | The id of the root element to draw the frontend into. Will default to `frontend`, if available, or the `<body>` element, if not. |
| `defaultPrivacy` | `composer.default_privacy` | The initial privacy setting to use for posts. This will default to `"unlisted"` if it isn't set. |
| `maxChars` | `composer.max_chars` | The maximum number of characters allowed in a post. |
| `locales` | *Not supported* | Custom localization information. |

###  Single-user mode:

If Snow is being hosted on a Mastodon server, then you might want to provide user and authorization information yourself rather than force the user to sign in through the Snow OAuth client.
This is called __single-user mode__ and can be specified by setting the `accessToken` configuration property.
If this property is missing, Snow will boot normally.

| Property | INITIAL_STATE equivalent | Description |
| -------- | ------------------------ | :---------- |
| `accessToken` | `meta.access_token` | Provides the access token for single-user mode. |
| `origin` | `meta.origin` | Provides the origin for Mastodon API requests when in single-user mode. Defaults to `/`, but this does nothing if `accessToken` isn't set. |

###  Display modes:

You can modify the appearance of Snow through the `display` configuration property, which should be an array of one or more of the following values:

| Value | Description |
| ----- | :---------- |
| `simple` | Removes text labels from the user interface. |
| `no-transparency` | Removes transparency from the user interface. |
| `reduce-motion` | Reduces the amount of motion effects in the user interface. |
| `full-colour` | Turns off the greyscale filter on images. |

The implementation of these display modes is largely handled by the Snow stylesheets.
There is not presently a means of setting display modes through `window.INITIAL_STATE`.

 - - -

##  Styling  ##

If you are installing Snow on a Mastodon server, then you can easily configure its appearance by setting a number of variables in the `variables.scss` file in `app/assets/stylesheets`.
The recognized variables are as follows:

###  Fonts:

Snow won't load any fonts for you, so you should set these to fonts loaded elsewhere by your server or else ones which users might reasonably be expected to have.

| Variable | Default Value | Description |
| -------- | ------------- | :---------- |
| `$snow-sans` | `"ChicagoFLF", "Chicago", "Arial", sans-serif` | The sans-serif font used by the frontend |
| `$snow-mono` | `"Andalé Mono", "Monaco", "Bitstream Vera", "DejaVu" monospace` | The monospace font used by the frontend |

###  Simple colours:

In order to make customizing Snow easier, the colour scheme has been reduced to just a few colours.
The default values for these colours use the "Print + Pastels" theme located in [`palettes.scss`](../styling/palettes.scss).
For more precision when customizing, look to the advanced colours further on.

| Variable | Default Value | Description |
| -------- | ------------- | :---------- |
| `$snow-backlight` | `$print_white` | The background colour for the frontend |
| `$snow-inkcolour` | `$print_black` | The foreground colour for the frontend |
| `$snow-notactive` | `$print_medium` | The foreground colour for inactive frontend elements |

###  Opacities:

These are the various opacity levels for certain Snow elements.

| Variable | Default Value | Description |
| -------- | ------------- | :---------- |
| `$` | `` |  |

###  Backgrounds:

These should take the form of the CSS `background` property.

| Variable | Default Value | Description |
| -------- | ------------- | :---------- |
| `$snow-background` | `$snow-backlight` | The background used by the main frontend |

###  Advanced Colours:

The colour scheme actually deployed by Snow allows for far more nuance than the basic colours outlined above.
As a matter of fact, virtually every component can be styled independently.
Setting the variables below allows you to develop a much more involved and/or nuanced theme, or to correct problems which arise during basic colour reconfiguration.

| Variable | Default Value | Description |
| -------- | ------------- | :---------- |
| `$` | `` |  |
