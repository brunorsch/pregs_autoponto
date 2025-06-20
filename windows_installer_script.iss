[Setup]
AppId={{BF25899D-9A4F-4137-A54B-584752538162}}
AppName=Pregs Autoponto
AppVersion=0.1.0
;AppVerName=Pregs Autoponto 0.1
AppPublisher=Pregs
AppPublisherURL=https://brunorsch.dev.br/
AppSupportURL=https://brunorsch.dev.br/
AppUpdatesURL=https://brunorsch.dev.br/
DefaultDirName={autopf}\\Pregs Autoponto
DefaultGroupName=Pregs Autoponto
AllowNoIcons=yes
UninstallDisplayIcon={app}\\pregs_autoponto.exe
SetupIconFile=windows\\runner\\resources\\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\\windows\\x64\\runner\\Release\\pregs_autoponto.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\\windows\\x64\\runner\\Release\\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\Pregs Autoponto"; Filename: "{app}\\pregs_autoponto.exe"
Name: "{autodesktop}\\Pregs Autoponto"; Filename: "{app}\\pregs_autoponto.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\\pregs_autoponto.exe"; Description: "{cm:LaunchProgram,Pregs Autoponto}"; Flags: nowait postinstall skipifsilent

