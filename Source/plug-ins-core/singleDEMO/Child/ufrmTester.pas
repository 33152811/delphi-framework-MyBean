unit ufrmTester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uIUIForm, uBeanFactory;

type
  TfrmTester = class(TForm, IUIForm)
  private
    { Private declarations }
  public
    procedure showAsMDI; stdcall;

    function showAsModal: Integer; stdcall;

    //�ر�
    procedure UIFormClose; stdcall;

    //�ͷŴ���
    procedure UIFormFree; stdcall;

    //��ȡ�������
    function getObject:TObject; stdcall;

    //��ȡʵ��ID
    function getInstanceID: Integer; stdcall;
  end;

var
  frmTester: TfrmTester;

implementation

{$R *.dfm}

{ TfrmTester }

function TfrmTester.getInstanceID: Integer;
begin

end;

function TfrmTester.getObject: TObject;
begin

end;

procedure TfrmTester.showAsMDI;
begin

end;

function TfrmTester.showAsModal: Integer;
begin
  ShowModal;
end;

procedure TfrmTester.UIFormClose;
begin
  close;
end;

procedure TfrmTester.UIFormFree;
begin
  self.Free;
end;

initialization
  beanFactory.RegisterBean('tester', TfrmTester);

end.
