program beanConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  mybean.console,
  mybean.tools.beanFactory,
  SysUtils,
  uILogic in '..\common\uILogic.pas';

var
  s:string;
  i, j:Integer;
begin
  try
    //��ʼ��mybean���
    applicationContextInitialize;

    writeLn('input i:');
    Readln(i);
    writeLn('input j:');
    Readln(j);
    WriteLn('sum result:' +
      IntToStr(
        (TMyBeanFactoryTools.getBean('sumExp') as ISumExp).sum(i, j)    //���ò��ִ���߼�
      )
    );

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('��������˳�����');

  Readln(s);


end.
