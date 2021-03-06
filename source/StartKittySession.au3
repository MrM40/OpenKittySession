#include <Array.au3>
;Argument 1: Session-name, which must be equeal to hostname!

; SET VARIABLES:

   Const $SessionName = $CmdLine[1] ;SessionName must be equal to Hostname!
   Global $SessionFld, $Kitty, $WinTitle, $PosX, $PosY, $SizeX, $SizeY, $SessionSpecificProperties[1]

ReadINI()

   Const $CommonSessionSettingsPath = $SessionFld & "~CommonSessionSettings.txt" ;Hold the common session properties which are shared by all sessions
   Const $SessionFilePath = $SessionFld & $SessionName & ".txt" ;File containing the session-specific properties
   Const $TmpSessionFilePath = EnvGet("TEMP") & "\KittySession.ktx" ; The temporary sessionfile used by kitte.exe

   ;Call functions:
   SetSessionSpecificProperties()
   ConstructTmpSessionFile()
   CallKitty()
   SetWindowsPossition()

   ;Get variables fron ini-file
   Func ReadINI()
	  Local $INIFileObj = FileOpen("StartKittySession.ini", 0)

	  $SessionFld = StringReplace(FileReadLine($INIFileObj, 1),"SessionFld=","")
	  ;MsgBox(0.,"$SessionFld",$SessionFld)

	  $Kitty=StringReplace(FileReadLine($INIFileObj, 2),"Kitty=","")
	  ;MsgBox(0,"$Kitty",$Kitty)

	  $PosX = StringReplace(FileReadLine($INIFileObj, 3),"PosX=","")

	  $PosY = StringReplace(FileReadLine($INIFileObj, 4),"PosY=","")

	  $SizeX = StringReplace(FileReadLine($INIFileObj, 5),"SizeX=","")
	  ;MsgBox(0,"$SizeX",$PosX)

	  $SizeY = StringReplace(FileReadLine($INIFileObj, 6),"SizeY=","")

	  FileClose($INIFileObj)

   EndFunc

   ;Set session-specific properties from the ession-file (i.e. $Username, $Password and $PublicKeyFile):
   Func SetSessionSpecificProperties()
	  ;Check if file exist:
	  if FileExists($SessionFilePath) = False Then
		 $SessionSpecificProperties[0] = "HostName\" & $SessionName & "\"
		 Return
	  EndIf

	  ;Get all lines from the file containing session-specific-properties ($SessionSpecificProperties):
	  Local $SessionFileObj = FileOpen($SessionFilePath, 0) ;Read mode
	  $SessionSpecificProperties = FileReadToArray($SessionFileObj)
	  FileClose($SessionFileObj)

	  ReDim $SessionSpecificProperties[UBound($SessionSpecificProperties)]

	  _ArrayAdd($SessionSpecificProperties,"HostName\" & $SessionName & "\")


   EndFunc

   ;Create temporary-session-file:
   Func ConstructTmpSessionFile()
	  Local $WriteLine = True

	  ;Crate new empty session-file in %temp%:
	  Local $TmpSessionFileObj = FileOpen($TmpSessionFilePath, 2) ;Write mode (erase previous contents)

	  ;Read all lines from file containing common session settings ($CommonSessionSettingsPath):
	  Local $CommonSessionSettingsObj = FileOpen($CommonSessionSettingsPath, 0) ;read-mode
	  ;Load all lines from common-session-settings-file to array:
	  Local $CommonSettings = FileReadToArray($CommonSessionSettingsObj)

	  ;Iterate all common-settings-array and compare with session-specific settings.
	  For $CommonLine in $CommonSettings
		 $WriteLine = True

		 For $NewSetting in $SessionSpecificProperties
			;if $NewSetting = "" then ContinueLoop
			If StringSplit($CommonLine,"\")[1] == StringSplit($NewSetting,"\")[1] then $WriteLine = False
		 Next

		 ;Write if it doesn't exist in the session-specific-array
		 If $WriteLine = True then
			FileWriteLine($TmpSessionFileObj,$CommonLine)
		 ;Else
			;FileWriteLine($TmpSessionFileObj,$NewSetting)
		 EndIf
	  Next

;~ 	  ;Write all properties in the session-specific-array to the temp. session file:
 	  For $Line in $SessionSpecificProperties
 		 FileWriteLine($TmpSessionFileObj,$Line)
 	  Next

	  FileClose($TmpSessionFileObj)
   EndFunc

   ; Execute kitty with arguments
   Func CallKitty()
	  $WinTitle = $SessionName
	  ;Set kitty cmd variable
	  $Kitty = $Kitty & " -title " & $WinTitle & " -kload " & """" & $TmpSessionFilePath & """"
	  ;MsgBox(0,"$Kitty",$Kitty)
	  ;Execute kitty with arguments
	  run($Kitty)
   EndFunc

   ; Move and resize kitty session windows
   Func SetWindowsPossition()
	  WinWait($WinTitle,"",2)
	  WinMove($WinTitle,"",$PosX,$PosY,$SizeX,$SizeY)
   EndFunc


