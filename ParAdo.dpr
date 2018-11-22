program ParAdo;

uses
  Vcl.Forms,
  uError,
  AdoSets,
  Vcl.Dialogs,
  System.SysUtils,
  uParAdo in 'uParAdo.pas' {MainForm};

{$R *.res}
var
  Initiated: Boolean;
  f: TextFile;
  OutputFileName, SetName: String;
  HasHeaders: Boolean;
  Colnr: Integer;
  SepChar: Char;
  Procedure ShowParametersAndTerminate;
  begin
    ShowMessage( 'ParAdo CSV-filename T/F Colnr SepChar SetName' );
    Application.Terminate;
  end;
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  if ParamCount <> 5 then
    ShowParametersAndTerminate;
  if not FileExists( ParamStr(1) ) then begin
    ShowMessageFMT( 'File %s does not exist.', [ExpandFileName( ParamStr(1) )] );
  end;

  HasHeaders := False;
  if UpperCase(ParamStr(2))='T' then
    HasHeaders := True
  else if UpperCase(ParamStr(2)) <> 'F' then
    ShowParametersAndTerminate;

  Try
    ColNr := StrToInt( ParamStr( 3 ) );
    if ColNr <=0 then
      ShowParametersAndTerminate;
  Except
    ShowParametersAndTerminate;
  End;

  if length(ParamStr(4)) > 1 then
    ShowParametersAndTerminate;
  SepChar := ParamStr( 4 )[1];

  SetName := ParamStr(5);

  MainForm.RealAdoSet1 := TRealAdoSet.CreateFromCSVFile(
    ParamStr(1),HasHeaders,SepChar,Colnr,SetName, MainForm, Initiated );

  if not Initiated then begin
    showmessageFmt( 'Cannot initiate ado set from file %s.', [ParamStr(1)] );
    Application.Terminate;
  end;
  OutputFileName := ExpandFileName( GetCurrentDir + '\' + SetName + '.ado' );
  AssignFile( f, OutputFileName ); Rewrite( f );
  MainForm.RealAdoSet1.ExportToOpenedTextFile( f );
  CloseFile( f );
  //Application.Run;
end.
