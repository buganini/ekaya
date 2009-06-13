;NSIS Modern User Interface
;Ekaya NSIS Installer script
;Written by Keith Stribley

; Some useful definitions that may need changing for different font versions
!ifndef VERSION
  !define VERSION '0.1.0'
!endif

!define APP_NAME 'Ekaya'
!define INSTALL_SUFFIX "ThanLwinSoft.org"

;--------------------------------
;Include Modern UI

  !include "MUI.nsh"

;--------------------------------
;General

  ;Name and file
  Name "${APP_NAME} (${VERSION})"
  Caption "Ekaya Input Method"

  OutFile "${APP_NAME}-${VERSION}.exe"
  InstallDir $PROGRAMFILES\${INSTALL_SUFFIX}
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\${INSTALL_SUFFIX}\${APP_NAME}" ""
  
  SetCompressor lzma

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "COPYING"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
  Icon "ekaya.ico"
  UninstallIcon "ekayaUninstall.ico"
;Installer Sections



Section "-!${APP_NAME}" SecApp
  
  IfFileExists "$INSTDIR" 0 BranchNoExist
    
    MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to overwrite existing ${APP_NAME} directory?" IDNO  NoOverwrite ; skipped if file doesn't exist

    BranchNoExist:
  
    SetOverwrite on ; NOT AN INSTRUCTION, NOT COUNTED IN SKIPPINGS

NoOverwrite:

  
  SetOutPath "$INSTDIR"
  File /oname=license.txt "COPYING"

  CreateDirectory "$INSTDIR\${APP_NAME}"
  SetOutPath "$INSTDIR\${APP_NAME}"
  File "ekaya.ico"
  ;File "Uninstall.ico"
  
  File "Release\ekaya.dll"
  File "Release\ekaya.dll*.manifest*"
  File "..\libkmfl-0.9.8\Release\libkmfl.dll"
  File "..\..\iconv-1.9.2.win32\bin\iconv.dll"
  File /r "doc"
  
  ExecWait 'regsvr32 /i /s "$INSTDIR\${APP_NAME}\ekaya.dll"' $0
  IfErrors 0 +2
	MessageBox MB_OK|MB_ICONEXCLAMATION "Warning: Regsvr32 failed to register Ekaya Text Service DLL"
  
  CreateDirectory "$INSTDIR\${APP_NAME}\kmfl"
  
  SetShellVarContext all
  ; set up shortcuts
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" \
	"$INSTDIR\${APP_NAME}\doc\ekaya.html" '' \
	"$INSTDIR\${APP_NAME}\ekaya.ico" 0 SW_SHOWNORMAL \
	"" "${APP_NAME}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}Uninstall.lnk" \
	"$INSTDIR\${APP_NAME}\Uninstall.exe" "" \
	"$INSTDIR\${APP_NAME}\ekayaUninstall.ico" 0 SW_SHOWNORMAL \
	"" "Uninstall ${APP_NAME}"
	
  ;Store installation folder
  WriteRegStr HKLM "Software\${INSTALL_SUFFIX}\${APP_NAME}" "" $INSTDIR

  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\${APP_NAME}\Uninstall.exe"

  ; add keys for Add/Remove Programs entry
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
                 "DisplayName" "${APP_NAME} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
                 "UninstallString" "$INSTDIR\${APP_NAME}\ekayaUninstall.exe"

SectionEnd

;Optional source - as a compressed archive
; hg archive -t tbz2 ekaya-0.1.0.tar.bz2
Section /o "Source" SecSource
	SetOutPath "$INSTDIR\${APP_NAME}"
	File ..\ekaya-${VERSION}.tar.bz2
SectionEnd

; Add more keyboard sections here as needed
Section "MyWin Burmese Unicode 5.1 keyboard" SecMyWin
	SetOutPath "$INSTDIR\${APP_NAME}\kmfl"
	File "kmfl\myWin.png"
	File "kmfl\myWin.jpg"
	File "kmfl\myWin2.2.kmn"
	File "kmfl\myWin2.2.html"
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecApp ${LANG_ENGLISH} "Install the ${APP_NAME} (version ${VERSION})."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecApp} $(DESC_SecApp)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInstFailed
	MessageBox MB_OK "You may want to rerun the installer as an Administrator or specify a different installation directory."

FunctionEnd

Function .onInstSuccess

	ExecShell "open" '"$INSTDIR\${APP_NAME}\doc\ekaya.html"'

FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  SetShellVarContext all

  IfFileExists "$INSTDIR" AppFound 0
    MessageBox MB_OK|MB_ICONEXCLAMATION "$INSTDIR\${APP_NAME} was not found! You may need to uninstall manually." 

AppFound:
  ExecWait 'regsvr32 /u /s "$INSTDIR\${APP_NAME}\ekaya.dll"' $0

  RMDir /r "$INSTDIR\docs"
  RMDir /r "$INSTDIR\kmfl"
  Delete /REBOOTOK "$INSTDIR\ekaya.dll"
  Delete /REBOOTOK "$INSTDIR\iconv.dll"
  Delete /REBOOTOK "$INSTDIR\libkmfl.dll"
  Delete /REBOOTOK "$INSTDIR\license.txt"
  Delete /REBOOTOK "$INSTDIR\ekaya.ico"
  
  Delete "$INSTDIR\ekaya-${VERSION}.tar.bz2"

  Delete /REBOOTOK "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"
  
  Delete  "$DESKTOP\${APP_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\${APP_NAME}"

  DeleteRegKey /ifempty HKLM "Software\${INSTALL_SUFFIX}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
  
  IfFileExists "$INSTDIR\workspace" 0 end
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "$INSTDIR\workspace exists. This may contain some of your own files. Do you want to remove it as well?" IDYES 0 IDNO end
  
  RMDir /REBOOTOK /r "$INSTDIR"

end:

SectionEnd

