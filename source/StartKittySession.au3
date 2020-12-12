;Argument 1: Session-name, which must be equeal to hostname!

; SET VARIABLES:
   Const $SessionName = $CmdLine[1] ;SessionName must be equal to Hostname!
   Global $HostName, $Username, $Password, $PublicKeyFile ;Session-specific properties
   Global $SessionFld, $Kitty, $WinTitle, $PosX, $PosY, $SizeX, $SizeY

   ReadINI()

   Const $CommonSessionSettingsPath = $SessionFld & "CommonSessionSettings.txt" ;Hold the common session properties which are shared by all sessions
   Const $SessionFilePath = $SessionFld & $SessionName & ".txt" ;File containing the session-specific properties
   Const $TmpSessionFilePath = EnvGet("TEMP") & "\KittySession.ktx" ; The temporary sessionfile used by kitte.exe

   ;Call functions:
   SetSessionSpecificProperties()
   ConstructTmpSessionFile()
   CallKitty()
   SetWindowsPossition()
   Sleep(1000)
   FileDelete($TmpSessionFilePath)

   ;Get variables fron ini-file
   Func ReadINI()
	  Local $INIFileObj = FileOpen("StartKittySession.ini", 0)

	  $SessionFld = StringReplace(FileReadLine($INIFileObj, 1),"SessionFld=","")
	  ;MsgBox(0,"$SessionFld",$SessionFld)

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
	  Local $SessionFileObj = FileOpen($SessionFilePath, 0) ;Read mode
	  ;MsgBox(0,"$SessionFilePath",$SessionFilePath)
	  $Username = FileReadLine($SessionFileObj,1)
	  $Password = FileReadLine($SessionFileObj,2)
	  $PublicKeyFile = FileReadLine($SessionFileObj,3)
	  $HostName = "HostName\" & $SessionName & "\"
	  FileClose($SessionFileObj)
	  ;MsgBox(0,"$Username",$Username)
   EndFunc

   ;Create temporary-session-file:
   Func ConstructTmpSessionFile()
	  ;Just make a copy of the template-file:
	  FileCopy($CommonSessionSettingsPath, $TmpSessionFilePath,1) ;1=Owerwrite
	  ;MsgBox(0,"$CommonSessionSettingsPath",$CommonSessionSettingsPath)
	  Local $TmpSessionFileObj = FileOpen($TmpSessionFilePath, 1) ;Write mode (append to end of file)

	  ;Write the session-specific properties to the temporary-session-file:
	  FileWriteLine($TmpSessionFileObj,"") ;In case last character in targetfile is not linefeed
	  FileWriteLine($TmpSessionFileObj,$HostName)
	  FileWriteLine($TmpSessionFileObj,$Username)
	  FileWriteLine($TmpSessionFileObj,$Password)
	  FileWriteLine($TmpSessionFileObj,$PublicKeyFile)
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