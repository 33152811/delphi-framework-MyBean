program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Vcl.Forms,
  uAppPluginContext,
  PluginTabControl in '..\..\mainForm\PluginTabControl.pas',
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain},
  uMainFormTools in '..\..\mainForm\uMainFormTools.pas',
  uPluginObject in '..\..\mainForm\uPluginObject.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  applicationContextIntialize();
  try
    Application.MainFormOnTaskbar := True;
    //TStyleManager.TrySetStyle('Cyan Dusk');
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    //������ǰ�ͷţ���������DLL��Դ�ٽ����ͷ�, ����������к���DLL�е���Դ�����ܻ�����AV�쳣
    frmMain.Free;
    frmMain := nil;
    applicationContextFinalize;
  end;
end.
