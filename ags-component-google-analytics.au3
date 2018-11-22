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

Global variables used in this component are :

 - $GAMP_DEBUG_OUPUT_CONSOLE {bool}
 - $GAMP_TRACKING_ENABLE {bool}
 - $GAMP_PROXY {string}
 - $GAMP_TRACKING_ID {string}
 - $GAMP_CRYPT_SALT {string}
 - $APP_NAME {string}
 - $APP_ID {string}
 - $APP_VERSION {string}

#ce ----------------------------------------------------------------------------


#include-once


#include <Crypt.au3>
#include "../../../vendor/@autoit-gui-skeleton/ags-component-http-request/ags-component-http-request.au3"


Opt('MustDeclareVars', 1)


;===============================================================================
; Send a request HTTP POST with payload data to server GAMP
;
; @param {string} $payload, the google payload to send with http POST on server GA (ex: 'v=1&t=pageview&tid=UA-1xxxxx-y&cid=....')
; @param {string} $proxy
; @param {bool} $tracking_enable
; @param {bool} $output_console

; @return void
;===============================================================================
Func hitGAMP($payload, $proxy="", $tracking_enable=False, $output_console=False)
   If($output_console=True) Then
	  ConsoleWrite("[DEBUG] payload => POST HTTP http://www.google-analytics.com " & $payload & @CRLF)
   EndIf

   If($tracking_enable=True) Then
	  Local $reponse = HttpPOST('http://www.google-analytics.com/collect', $payload, $proxy)
	  If($output_console=True) Then
		 ConsoleWrite("[DEBUG] HTTP Response Status = " & $reponse.Status & @CRLF)
		 ConsoleWrite("[DEBUG] HTTP Response Text = " & $reponse.ResponseText & @CRLF)
	  EndIf
   EndIf
EndFunc


;===============================================================================
; Hit GAMP for a pageview
;===============================================================================
Func hitGAMP_pageview($pageHostname, $pageName, $pageTitle)
   local $payload = payload_GAMP_pageview($GAMP_TRACKING_ID, $APP_NAME, $APP_ID, $APP_VERSION, $GAMP_CRYPT_SALT, $pageHostname, $pageName, $pageTitle)
   hitGAMP($payload, $GAMP_PROXY, $GAMP_TRACKING_ENABLE, $GAMP_DEBUG_OUPUT_CONSOLE)
EndFunc


;===============================================================================
; Hit GAMP for a screenview
;===============================================================================
Func hitGAMP_screenview($screenName)
   Local $payload = payload_GAMP_screenview($GAMP_TRACKING_ID, $APP_NAME, $APP_ID, $APP_VERSION, $GAMP_CRYPT_SALT, $screenName)
   hitGAMP($payload, $GAMP_PROXY, $GAMP_TRACKING_ENABLE, $GAMP_DEBUG_OUPUT_CONSOLE)
EndFunc


;===============================================================================
; Hit GAMP for an event
;===============================================================================
Func hitGAMP_event($eventCategory, $eventAction, $eventLabel="", $eventValue="")
   Local $payload = payload_GAMP_event($GAMP_TRACKING_ID, $APP_NAME, $APP_ID, $APP_VERSION, $GAMP_CRYPT_SALT, $eventCategory, $eventAction, $eventLabel, $eventValue)
   hitGAMP($payload, $GAMP_PROXY, $GAMP_TRACKING_ENABLE, $GAMP_DEBUG_OUPUT_CONSOLE)
EndFunc


;===============================================================================
; Hit GAMP for a screenview and a pageview
;===============================================================================
Func hitGAMP_screenview_AND_pageview($screenName, $pageHostname, $pageName, $pageTitle)
   hitGAMP_screenview($screenName)
   hitGAMP_pageview($pageHostname, $pageName, $pageTitle)
EndFunc


;===============================================================================
; Prepare a generic payload to use for all hit GAMP
;
; @param {string} $trackingId, gamp variable -> tid	'UA-XXXX-Y'
; @param {string} $appName, gamp variable -> an 	'eMailing'
; @param {string} $appId, gamp variable -> aid 	'aot.dep.padi.eMailing'
; @param {string} $appVersion, gamp variable -> av 	'1.2.0'
; @param {string} $appSalt, use to crypt with salt cid
; @return {string} $payload
;===============================================================================
Func payload_GAMP_main($trackingId, $appName, $appId, $appVersion, $appSalt)
   Local $cid = GetCID($appSalt)
   Local $payload = "v=1&tid="&$trackingId&"&cid="&$cid&"&an="&URLEncode($appName)&"&aid="&URLEncode($appId)&"&av="&$appVersion

   Return $payload
EndFunc


;===============================================================================
; Prepare a payload for pageview
;
; @param {string} $trackingId, gamp variable -> tid	'UA-XXXX-Y'
; @param {string} $appName, gamp variable -> an 	'eMailing'
; @param {string} $appId, gamp variable -> aid 	'aot.dep.padi.eMailing'
; @param {string} $appVersion, gamp variable -> av 	'1.2.0'
; @param {string} $appSalt, use to crypt with salt cid
; @param {string} $pageHostname,	gamp variable -> &dh=mydemo.com   // Document hostname
; @param {string} $pageName, gamp variable -> &dp=/home        // Page
; @param {string} $pageTitle, gamp variable -> &dt=homepage     // Title
; @return {string} $payload
;===============================================================================
Func payload_GAMP_pageview($trackingId, $appName, $appId, $appVersion, $appSalt, $pageHostname, $pageName, $pageTitle)
   Local $hitType = "pageview"
   Local $payload = payload_GAMP_main($trackingId, $appName, $appId, $appVersion, $appSalt)
   $payload = $payload&"&t="&$hitType&"&dh="&URLEncode($pageHostname)&"&dp="&URLEncode($pageName)&"&dt="&URLEncode($pageTitle)

   return $payload
EndFunc


;===============================================================================
; Prepare a payload for screenview
;
; @param {string} $trackingId, gamp variable -> tid	'UA-XXXX-Y'
; @param {string} $appName, gamp variable -> an 	'eMailing'
; @param {string} $appId, gamp variable -> aid 	'aot.dep.padi.eMailing'
; @param {string} $appVersion, gamp variable -> av 	'1.2.0'
; @param {string} $appSalt, use to crypt with salt cid
; @param {string} $screenName		gamp variable -> cd		'High%20Scores'
; @return {string} $payload
;===============================================================================
Func payload_GAMP_screenview($trackingId, $appName, $appId, $appVersion, $appSalt, $screenName)
   Local $hitType = "screenview"
   Local $payload = payload_GAMP_main($trackingId, $appName, $appId, $appVersion, $appSalt)
   $payload = $payload&"&t="&$hitType&"&cd="&URLEncode($screenName)

   return $payload
EndFunc


;===============================================================================
; Prepare a payload event
;
; @param {string} $trackingId, gamp variable -> tid	'UA-XXXX-Y'
; @param {string} $appName, gamp variable -> an 	'eMailing'
; @param {string} $appId, gamp variable -> aid 	'aot.dep.padi.eMailing'
; @param {string} $appVersion, gamp variable -> av 	'1.2.0'
; @param {string} $appSalt, use to crypt with salt cid
; @param {string} $screenName, gamp variable -> cd		'High%20Scores'
; @param {string} $eventCategory, gamp variable -> ec		'Click'
; @param {string} $eventAction, gamp variable -> ea		'Download'
; @param {string} $eventLabel, gamp variable -> el		''
; @param {string} $eventValue, gamp variable -> ev		''
; @return {string} $payload
;===============================================================================
Func payload_GAMP_event($trackingId, $appName, $appId, $appVersion, $appSalt, $eventCategory, $eventAction, $eventLabel="", $eventValue="")
   Local $hitType = "event"
   Local $payload = payload_GAMP_main($trackingId, $appName, $appId, $appVersion, $appSalt)
   $payload = $payload&"&t="&$hitType&"&ec="&URLEncode($eventCategory)&"&ea="&URLEncode($eventAction)

   If($eventLabel<>"") Then
	  $payload = $payload&"&el="&URLEncode($eventLabel)
   EndIf
   If($eventValue<>"") Then
	  $payload = $payload&"&ev="&$eventValue
   EndIf

   return $payload
EndFunc


;===============================================================================
; Get the CID from @UserName environment variable, and encrypt it.
;
; @param {string} $data
; @return {string} the username encrypted
;===============================================================================
Func GetCID($appSalt)
   return Encrypt(@UserName, $appSalt, $CALG_RC4)
EndFunc


;===============================================================================
; Crypt a string
;
; @deprecated
;
; @param {string} $data
; @param {string} $salt
; @param {string} $algorithm
; @return {string}  $encrypted
;===============================================================================
Func Encrypt($data, $salt, $algorithm = $CALG_RC4)
   _Crypt_Startup()
   Local $encrypted = _Crypt_EncryptData($data, $salt, $algorithm)
   _Crypt_Shutdown()
   Return $encrypted
EndFunc


;===============================================================================
; Decrypt a string encrypted
;
; @deprecated
;
; @param {string} $data
; @param {string} $salt
; @param {string} $algorithm
; @return {string}  $decrypted
;===============================================================================
Func Decrypt($data, $salt, $algorithm = $CALG_RC4)
   _Crypt_Startup()
   Local $decrypted = BinaryToString(_Crypt_DecryptData($data, $salt, $algorithm))
   _Crypt_Shutdown()
   Return $decrypted
EndFunc


;===============================================================================
; Hash a given data wih SHA512 alogrithm
;
; @deprecated
;
; @param {string} $data
; @return {string} the username encrypted
;===============================================================================
Func Hash_SHA512($data)
   return _Crypt_HashData($data, $CALG_SHA_512)
EndFunc
