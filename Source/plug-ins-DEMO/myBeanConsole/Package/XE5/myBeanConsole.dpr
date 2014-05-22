program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uAppPluginContext,
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain},
  PluginTabControl in '..\..\mainForm\PluginTabControl.pas',
  uPluginObject in '..\..\mainForm\uPluginObject.pas',
  uMainFormTools in '..\..\mainForm\uMainFormTools.pas';

{R *.res}

begin
  Application.Initialize;
  applicationContextIntialize();
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    //������ǰ�ͷţ���������DLL��Դ�ٽ����ͷ�, ����������к���DLL�е���Դ�����ܻ�����AV�쳣
    frmMain.Free;
    frmMain := nil;
    applicationContextFinalize;
  end;
end.
