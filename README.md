AGS-component-google-analytics
==============================

> Add the feature to track activity with Google Analytics Measurement Protocol inside an AutoIt application built with the AGS framework.



<br/>

## How to install AGS-component-google-analytics ?

In order to simplify the management of the dependencies of an AutoIt project built with AGS framework, we have diverted form its initial use the dependency manager npm, and its evolution Yarn. This allows us to manage the dependencies of an AGS project with other AutoIt libraries, and to share these AutoIt packages from the npmjs.org repository. All AGS packages hosted in this npmjs repository belong to [@autoit-gui-skeleton organization](https://www.npmjs.com/org/autoit-gui-skeleton)

We assume that you have already install [Node.js](https://nodejs.org/) and [Yarn](https://yarnpkg.com/lang/en/), for example with [Chocolatey](https://chocolatey.org/), so to install AGS-component-http-request, just type in the root folder of your project where the `package.json` is saved :

```
λ  yarn add @autoit-gui-skeleton/ags-component-google-analytics --modules-folder web/vendor
```

This package is installed into the `./vendor` directory. To use it in your AutoIt program, you need to include this library with this instruction:

```autoit
#include 'vendor/@autoit-gui-skeleton/ags-component-google-analytics/ags-component-google-analytics.au3'
```



<br/>

## AGS's vendor directory

To install AutoIt dependencies in the `./vendor` directory, and not in the default directory of Node.js `./node_modules`, you must add the `--modules-folder vendor` option. We force this choice to avoid any confusion with a Node.js project.

Note that with an AGS project, it is not necessary to explicitly write this option on the command line, thanks to the `.yarnrc` file stored at the root of the project. Yarn automatically use this file to add an additional configuration of options.

```
 #./.yarnrc
 --modules-folder vendor
 ```

So with this file you can run `yarn add @autoit-gui-skeleton/ags-component-google-analytics` to install the dependencies directly into the appropriate `./vendor` directory.



<br/>

## AGS-component-google-analytics

### Description

With AGS-component-google-analytics, you can track user activity inside an AutoIt application with the Measurement Protocol.




### Available methods

This library provides few methods:

 Methods | Description
---------|-------------
`hitGAMP($payload)` | Send a request HTTP POST with payload data to server GAMP
`hitGAMP_pageview($pageHostname, $pageName, $pageTitle)` | Hit GAMP for a pageview
`hitGAMP_screenview($screenName)` | Hit GAMP for a screenview
`hitGAMP_event($eventCategory, $eventAction, $eventLabel="", $eventValue="")` | Hit GAMP for an event
`hitGAMP_screenview_AND_pageview($screenName, $pageHostname, $pageName, $pageTitle)` | Hit GAMP for a screenview and a pageview



### Configuration of component AGS-component-google analytics

#### Define behavior in configuration file `./config/parameters.ini`

With AGS, you must have the configuration file `./config/parameters.ini`. This file must not save with control version. You can use `./config/parameters.ini.dist` as a “template” of what your parameters.ini file should look like. Set parameters here that may be different on each application. Only this file is save with control version and push on remote server.

To configure the behavior of this component, you can set its options in this configuration file. The configuration use the section `AGS_GOOGLE_ANALYTICS`.

```ini
## ./config/parameters.ini ##
[AGS_GOOGLE_ANALYTICS]
; [OPTIONAL] active debug output in console for all HTPP resquest send with GAMP
GAMP_DEBUG_OUPUT_CONSOLE=1

; [OPTIONAL] active tracking with Google Analytics Measurement Protocol
GAMP_ANALYTICS_CONSENT=1
```

If this variable are not defined in configuration file, so, by default `$GAMP_DEBUG_OUPUT_CONSOLE`, and `$GAMP_TRACKING_ENABLE` are set to `False`.

In this component we use an another component [AGS-component-http-request](https://yarnpkg.com/fr/package/@autoit-gui-skeleton/ags-component-http-request). This library is used to send HTTP request in GET or POST method, and with or wihtout behind a corporate proxy, in order to send data to GA server (hit with GAMP). So you can also configure this component. For example, you can set a proxy for all HTTP connections, or set different types of timeouts. By default, this component looks in the configuration file if a proxy is defined in the PROXY variable in the AGS_HTTP_REQUEST section.

```ini
## ./config/parameters.ini ##

[AGS_HTTP_REQUEST]
; [OPTIONAL] Use a proxy for http connexion or choose NONE to disable it
# PROXY=NONE
PROXY=http://myProxy.com:20100
```


#### Set constants in ./src/GLOBALS.au3

In AGS framework all constants and global variables are set in one place `./src/GLOBALS.au3`, with the exception to global variables of graphic elements which are set in each specific view file. AGS-component-google-analytics use also 5 global variables. If only one of these variables is not defined then the program returns an error and stops immediately

```autoit
; The google tracking id to used
Global const $GAMP_TRACKING_ID = "UA-xxxxxxxxx-y"

; A string used as a salt in encryption algorithm
Global const $GAMP_CRYPT_SALT = "2080-M3-M?GADR1Vx"

; Application main constants
Global Const $APP_NAME = "test"
Global Const $APP_ID = "acme.test"
Global Const $APP_VERSION = "1.2.3"
```




<br/>

## About

### Contributing

Comments, pull-request & stars are always welcome !

### License

Copyright (c) 2018 by [v20100v](https://github.com/v20100v). Released under the MIT license.
