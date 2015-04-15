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
    ExecuteLoadLibFiles('demoPlugins\*.dll');

    // ֱ�Ӽ���plug-insĿ¼�µ�BPL���
    ExecuteLoadLibFiles('demoPlugins\*.bpl');

    // ֱ�Ӽ���EXE��ǰĿ¼�µ�DLL���
    //  �Ƽ�������ŵ�ͳһĿ¼������м��أ�������ص�������mybean�Ĳ��
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
