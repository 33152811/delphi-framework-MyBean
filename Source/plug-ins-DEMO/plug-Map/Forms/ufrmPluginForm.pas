unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmPluginForm = class(TBasePluginForm)
    btnPutObject: TButton;
    btnGetObject: TButton;
    procedure btnGetObjectClick(Sender: TObject);
    procedure btnPutObjectClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  TTesterObject = class(TObject)
  private
    FName:String;
  public

  end;

var
  frmPluginForm: TfrmPluginForm;

implementation

uses
  mBeanFrameVars, uIPluginForm, uMyBeanMapTools;

{$R *.dfm}

procedure TfrmPluginForm.btnGetObjectClick(Sender: TObject);
var
  lvObj:TTesterObject;
begin
  lvObj := TMyBeanMapTools.getObject('tester') as TTesterObject;
  if lvObj = nil then raise Exception.Create('����ֿ���û���ҵ�����Ķ���!');
  ShowMessage(lvObj.FName);
end;

procedure TfrmPluginForm.btnPutObjectClick(Sender: TObject);
var
  lvObj:TTesterObject;
begin
  lvObj := TTesterObject.Create;
  lvObj.FName := 'ȫ�ֶ������';
  TMyBeanMapTools.setObject('tester', lvObj);
  ShowMessage('���ȫ�ֶ���ɹ�,���������������л�ȡ�ö���');
end;

end.
