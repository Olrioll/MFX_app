; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "MFX"
#define MyAppVersion "0.1.9"
#define MyAppPublisher "MFX"
#define MyAppURL "mfx.com"
#define MyAppExeName "MFXLauncher.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{6D43F801-B092-40A9-AE6A-E1117271D31B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=lic.txt
InfoAfterFile=info_after.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
OutputDir=.
OutputBaseFilename=MFXSetup
SetupIconFile=appIcon.ico
WizardImageFile=finish.bmp
WizardImageStretch=no
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
;Source: "{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "files\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "settings_files\*"; DestDir: "{localappdata}\{#MyAppPublisher}\{#MyAppName}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; VC++ redistributable runtime. Extracted by VC2017RedistNeedsInstall(), if needed.
Source: "Redist\vc_redist.x64.exe"; DestDir: {tmp}; Flags: dontcopy

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
;Name: "{autodesktop}\Test Station User Guide"; Filename: "{app}\TestStation user guide.pdf"; Tasks: desktopicon

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; \
Parameters: "/quiet"; Check: VC2017RedistNeedsInstall ; Flags: waituntilterminated
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function VC2017RedistNeedsInstall: Boolean;
var 
  Version: String;
begin
  if RegQueryStringValue(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Version', Version) then
  begin
    // Is the installed version at least 14.14 ? 
    Log('VC Redist Version check : found ' + Version);
    Result := (CompareStr(Version, '14.29.30135.0')<0); 
  end
  else 
  begin
    // Not even an old version installed
    Result := True;
  end;
  if (Result) then
  begin
    ExtractTemporaryFile('vc_redist.x64.exe');
  end;
end;
