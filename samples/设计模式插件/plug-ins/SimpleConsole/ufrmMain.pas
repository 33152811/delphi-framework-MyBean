unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mybean.tools.beanFactory,
  mybean.core.intf, IniFiles, mybean.ex.designmode.intf, uIDEMO;

type
  TfrmMain = class(TForm, ISubscribeListener, IMessageDispatch)
    Memo1: TMemo;
    edtMsg: TEdit;
    btnDispatchMsg: TButton;
    btnSubscribe: TButton;
    btnRemoveSubscribe: TButton;
    procedure btnDispatchMsgClick(Sender: TObject);
    procedure btnRemoveSubscribeClick(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FSubscriberID:Integer;
  public
    destructor Destroy; override;

    /// <summary>
    ///   �����һ��������
    /// </summary>
    /// <param name="pvSubscriberID"> ������ID </param>
    /// <param name="pvSubscriber"> ������ </param>
    procedure OnAddSubscriber(pvSubscriberID: Integer; const pvSubscriber:
        IInterface); stdcall;

    /// <summary>
    ///   �Ƴ���һ��������
    /// </summary>
    /// <param name="pvSubscriberID"> ������ID </param>
    procedure OnRemoveSubscriber(pvSubscriberID: Integer); stdcall;

  public
    /// <summary>
    ///   �յ������߷�������Ϣ
    /// </summary>
    procedure DispatchMsg(pvMsg:PAnsiChar); stdcall;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mybean.ex.designmode.utils;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // ��tester�����ߣ���Ӷ���������(������������/ȡ�����Ķ���)
  GetPublisher('tester').AddSubscribeListener(Self);

  
end;

procedure TfrmMain.OnAddSubscriber(pvSubscriberID: Integer;
  const pvSubscriber: IInterface);
begin
  Memo1.Lines.Add(Format('������һ��������[%d]', [pvSubscriberID]));
end;

procedure TfrmMain.OnRemoveSubscriber(pvSubscriberID: Integer);
begin
  Memo1.Lines.Add(Format('�Ƴ��˶�����[%d]', [pvSubscriberID]));
end;

destructor TfrmMain.Destroy;
begin
  GetPublisher('tester').RemoveSubscribeListener(Self);
  inherited;
end;

procedure TfrmMain.DispatchMsg(pvMsg: PAnsiChar);
begin
  Memo1.Lines.Add('���ܵ������߷�������Ϣ:' + pvMsg);
end;

procedure TfrmMain.btnDispatchMsgClick(Sender: TObject);
var
  lvPublisher:IPublisher;
  lvIntf:IInterface;
  lvDispatcher:IMessageDispatch;
  i:Integer;
  s:AnsiString;
begin
  s := edtMsg.Text;
  lvPublisher := GetPublisher('tester');
  for i := 0 to lvPublisher.GetSubscriberCount - 1 do
  begin
    lvPublisher.GetSubscriber(i, lvIntf);
    if lvIntf.QueryInterface(IMessageDispatch, lvDispatcher) = S_OK then
    begin
      lvDispatcher.DispatchMsg(PAnsiChar(s));
    end;
  end;

  s := '';


end;

procedure TfrmMain.btnRemoveSubscribeClick(Sender: TObject);
begin
  GetPublisher('tester').RemoveSubscriber(FSubscriberID);
  FSubscriberID := 0;
end;

procedure TfrmMain.btnSubscribeClick(Sender: TObject);
begin
  if FSubscriberID <> 0 then raise Exception.Create('�Ѿ�����');  
  FSubscriberID := GetPublisher('tester').AddSubscriber(Self);
end;

end.
