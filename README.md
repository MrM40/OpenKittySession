# OpenKittySession
Make it possible to share a template-session-file, with common session properties, between all your sessioin-files.
Additionally set size and location of the Kitty terminal window.

How doest it work:

1: Create a template session-file which include common-properties, which will be shared by all sessions.
   This will typically just be a copy of Default%20Settings.ktx, which is created by kitty.
   Call this templatefile "CommonSessionSettings.txt"
   
2: Create a sessionfile containing only the session-specific properties.
   For now the only supported properties are:
   
	UserName\xxx\
	Password\xxx\
	PublicKeyFile\xxx\
		
   This sessionfile should be called e.g. "SRV01.local.txt" (i.e. equal to hostname or optional IP address).
    
3: Modify the StartKittySession.ini:
   The "SessionFld" property is a folderpath to where "CommonSessionSettings.txt" and "SRV01.local" are located.
   E.g. "SessionFld=Y:\KittySessions\"
   
4: To call the session use "StartKittySession.exe SRV01.local"
   StartKittySession.exe and StartKittySession.ini must be located in the same folder.
   

The tool is an AutoIt v3 compiled script, created with the AutoIt editor SciTe-Lite.
_
