#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=filecheck.ico
#AutoIt3Wrapper_Res_Description=Checks X(array) files with datediff
#AutoIt3Wrapper_Res_Fileversion=1.2017.9.7
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <Date.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3> 	;FileExists
#include <WinAPIFiles.au3>		;FileExists

Global $name = "filecheck"
Global $logfile = @ScriptDir & "\" & $name &"_" & @YEAR & @MON & ".log"
Global $oErrorHandler = ObjEvent("AutoIt.Error", "_LogFunc")

$localFile = IniRead("config.ini", "config", "localFile", "xx")
$netFile = IniRead("config.ini", "config", "netFile", "xx")
$server = IniRead("config.ini", "config", "server", "")
$checks = IniRead("config.ini", "config", "checks", "5")
$waittime = IniRead("config.ini", "config", "waittime", "10")
$checktyp = IniRead("config.ini", "config", "checktyp", "0")
$displaysame = IniRead("config.ini", "config", "displaysame", "0")

if FileExists(@ScriptDir & "\config.ini") Then
; FileSetAttrib(@ScriptDir & "\config.ini", "+H")

Else
IniWrite(@ScriptDir & "/config.ini", "config", "localFile",'')
IniWrite(@ScriptDir & "/config.ini", "config", "netFile",'')
IniWrite(@ScriptDir & "/config.ini", "config", "server",'')
IniWrite(@ScriptDir & "/config.ini", "config", "checks",'')
IniWrite(@ScriptDir & "/config.ini", "config", "waittime",'')
IniWrite(@ScriptDir & "/config.ini", "config", "checktyp",'')
IniWrite(@ScriptDir & "/config.ini", "config", "displaysame",'0')
; FileSetAttrib(@ScriptDir & "\config.ini", "+H")
EndIf

; Hier gehts los

;~ Local $answer = MsgBox(1, "FileCheck", "This Script check two files with datediff " _
;~ 		 & @CRLF _
;~ 		 & @CRLF & "*************************************************" _
;~ 		 & @CRLF & "** File detect **" _
;~ 		 & @CRLF & "*************************************************")
;~ If $answer = 2 Then Exit

Local $iCount = 0
Local $iDate = 2
Local $msg = "" ; für Nachrichten
local $fileA = ""
Local $fileB = ""

IF stringlen($server) > 7 Then
	Local $iPing = false
	For $i = 0 to $checks Step 1
		$iPing = Ping($server,1500)
	Next
	IF not $iPing Then
		_FileWriteLog($logfile, " Server nicht erreichbar" & $server)
		MsgBox(1,"Server", "Server per PING nicht erreichbar!")
		Exit
	Else
		_FileWriteLog($logfile, " Server erreichbar ...")
	EndIf
EndIf

Local $aLocalFile = StringSplit($localFile, ',', $STR_ENTIRESPLIT)
Local $aNetFile = StringSplit($netFile, ',', $STR_ENTIRESPLIT)

;Hier noch prüfen ob beide arrays gleich lang

;~ For $iCount = 0 to $checks
	for $iArray = 1 To $aLocalFile[0]

		$fileA = $aLocalFile[$iArray]
		$fileB = $aNetFile[$iArray]

		Local $iCheck = FileCheck($fileA, $fileB)
		if $iCheck = 0 Then
			; Alles gut weiter
			_CheckDate(_CompareFileTimeEx($fileA, $fileB, $checktyp))
		Else
			If $iCheck = 1 Then
				$msg = "Datei nicht gefunden: " & $fileA
			ElseIf $iCheck = 2  Then
				$msg = "Datei nicht gefunden: " & $fileB
			ElseIf $iCheck = 3 Then
				$msg = "Beide Dateien nicht gefunden: " &  $fileA & @CRLF & $fileB
			EndIf
			MsgBox(1,"Datei nicht gefunden!", $msg)
			_FileWriteLog($logfile, $msg)
		EndIf
	Next
;~ 		sleep( $waittime )
;~ 		$iCount = $iCount + 1
;~ Next

_FileWriteLog($logfile, $name & " executed.         <----")

Exit

Func _CheckDate($iResult)
	IF $iResult = 1 Then
		$msg =  "Lokale Datei ist neuer: " & $fileA
						MsgBox(1,"Dateivergleich", $msg)
	ElseIf $iResult = -1 Then
		$msg = "Netzwerkdatei ist neuer: " & $fileB
						MsgBox(1,"Dateivergleich", $msg)
	Else
		$msg = "Beide Dateien sind identisch."
		if $displaysame = 1 then MsgBox(1,"Dateivergleich", $msg)
	EndIf
	_FileWriteLog($logfile, $msg)
EndFunc

Func FileCheck($hSource, $hDestination)
	; Returns		0 : all OK
	;				1 : Source not found
	; 				2 : Destination not found
	;				3 : both not found
	Local $iReturn = 0
	Local $iFileExists = FileExists($hSource)
	IF $iFileExists Then
			$iReturn = 0
	Else
			$iReturn = 1
	EndIf

	$iFileExists = FileExists($hDestination)
	IF $iFileExists Then
			$iReturn = $iReturn +0
	Else
			$iReturn = $iReturn + 2
	EndIf
	Return $iReturn
EndFunc

Func _CompareFileTimeEx($hSource, $hDestination, $iMethod)
	;Parameters ....:       $hSource -      Full path to the first file
	;                       $hDestination - Full path to the second file
	;                       $iMethod -      0   The date and time the file was modified
	;                                       1   The date and time the file was created
	;                                       2   The date and time the file was accessed
	;Return values .:                       -1  The Source file time is earlier than the Destination file time
	;                                       0   The Source file time is equal to the Destination file time
	;                                       1   The Source file time is later than the Destination file time
	;Author ........:       Ian Maxwell (llewxam @ AutoIt forum)
	$aSource = FileGetTime($hSource, $iMethod, 0)
	$aDestination = FileGetTime($hDestination, $iMethod, 0)
	For $a = 0 To 5
		If $aSource[$a] <> $aDestination[$a] Then
			If $aSource[$a] < $aDestination[$a] Then
				Return -1
			Else
				Return 1
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_CompareFileTimeEx

Func _LogFunc($oLog)
	_FileWriteLog($logfile, $oLog)
EndFunc   ;==>_LogFunc
