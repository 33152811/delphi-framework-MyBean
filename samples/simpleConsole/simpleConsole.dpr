program simpleConsole;

uses
  FastMM4,
  FastMM4Messages,
  mybean.console,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  try
    // ֱ�Ӽ���plug-insĿ¼�µ�DLL���
    ExecuteLoadLibFiles('plug-ins\*.dll');

    // ֱ�Ӽ���plug-insĿ¼�µ�BPL���
    ExecuteLoadLibFiles('plug-ins\*.bpl');

    // ֱ�Ӽ���EXE��ǰĿ¼�µ�DLL���
    ExecuteLoadLibFiles('*.dll');

    // ����configPluginsĿ¼�µĲ�������ļ�(�������)
    ExecuteLoadBeanFromConfigFiles('configPlugins\*.plug-ins');
    
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    // �ͷ�������
    Application.MainForm.Free;

    // �������ݹ������Ķ���, �ͷŲ��, ж��DLL/BPl
    ApplicationContextFinalize;
  end;
end.
