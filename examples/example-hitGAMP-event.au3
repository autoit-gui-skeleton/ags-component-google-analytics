#cs ----------------------------------------------------------------------------
ags-component-google-analytics

With the The Google Analytics Measurement Protocol (GAMP), it allows developers
to make HTTP requests to send raw user interaction data directly to Google
Analytics servers. This allows developers to measure how users interact with
their business from almost any environment.

Component title   : google-analytics
AutoIt version    : 3.3.14.5
Author            : v20100v <7567933+v20100v@users.noreply.github.com>
Package           : AGS version 1.0.0

Example

#ce ----------------------------------------------------------------------------



#include "../ags-component-google-analytics.au3"
#include <Date.au3>


Opt('MustDeclareVars', 1)

; Global variables required
Global Const $GAMP_DEBUG_OUPUT_CONSOLE = True
Global Const $GAMP_TRACKING_ENABLE = True
Global Const $GAMP_PROXY = "http://proxy.ac-orleans-tours.fr:8080"
Global Const $GAMP_TRACKING_ID = "UA-106410803-5"
Global Const $APP_NAME = "test"
Global Const $APP_ID = "acme.test"
Global Const $APP_VERSION = "1.2.3"
Global Const $APP_SALT = "2080-M3-M?GADR1Vx"


; Start application

; Start a timer to calculate the time of execution application
Local $timerinit = TimerInit()
local $now = _NowCalc()

; $eventCategory
; $eventAction
; $eventLabel
; $eventValue
hitGAMP_event("application", "start", "date_now", $now)

sleep(2000)

Local $total_time_execution = Round(TimerDiff($timerinit)/1000, 0)
hitGAMP_event("application", "Stop", "total_time_execution", $total_time_execution)
