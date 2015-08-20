unit uBasePluginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ComObj,
  mybean.core.intf,  mybean.tools.beanFactory;

type
  TBasePluginForm = class(TForm,
    IFreeObject,
    IBeanConfigSetter)
  private
    FInstanceID: string;
  protected
    __pass:AnsiString;
    FBeanConfigStr:string;
    procedure DoClose(var Action: TCloseAction); override;
  protected
    /// <summary>
    ///   ���������е�Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   �����ļ���JSon��ʽ���ַ���
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); virtual; stdcall;
  protected
    //��ȡʵ��Handle
    function getInstanceID: string; stdcall;
    //��ȡ�������
    function getObject: TObject; stdcall;
    procedure ShowAsChild(Parent: TWinControl); stdcall;
    function showAsModal: Integer; stdcall;
    procedure showAsNormal(); stdcall;
    //�رպ��ͷŴ���
    procedure closeForm; stdcall;
  protected
    procedure FreeObject; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override; 
  end;

implementation


constructor TBasePluginForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInstanceID := CreateClassID;
end;

destructor TBasePluginForm.Destroy;
begin
  //�����������д��ڸĽӿ�������Ƴ�(���������Ƴ�)
  TMyBeanFactoryTools.removeObject(AnsiString(FInstanceID));

  inherited Destroy;
end;

procedure TBasePluginForm.DoClose(var Action: TCloseAction);
begin
  if not (fsModal in self.FFormState) then action := caFree;
  inherited DoClose(Action);
end;

function TBasePluginForm.getInstanceID: string;
begin
  Result := FInstanceID;
end;

function TBasePluginForm.getObject: TObject;
begin
  Result := Self;
end;

procedure TBasePluginForm.FreeObject;
begin
  Self.Free;
end;

procedure TBasePluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  FBeanConfigStr :=String(AnsiString(pvBeanConfig));
end;

procedure TBasePluginForm.ShowAsChild(Parent: TWinControl);
begin
  Self.BorderStyle := bsNone;
  Self.Parent := Parent;
  Self.Align := alClient;
  self.Show;
end;

function TBasePluginForm.showAsModal: Integer;
begin
  Result := ShowModal();
end;

procedure TBasePluginForm.showAsNormal;
begin
  Self.Show;
end;

{ TBasePluginForm }
procedure TBasePluginForm.closeForm;
begin
  Self.Close;
end;

end.
