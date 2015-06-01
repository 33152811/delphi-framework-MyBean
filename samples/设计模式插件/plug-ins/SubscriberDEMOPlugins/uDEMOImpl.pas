unit uDEMOImpl;

interface

uses
  mybean.core.objects, uIDEMO;

type
  TDEMOSubscriber = class(TMyBeanInterfacedObject, IMessageDispatch)
  public
    procedure DispatchMsg(pvMsg:PAnsiChar); stdcall;
  end;

implementation

uses
  Dialogs;

{ TDEMOSubscriber }

procedure TDEMOSubscriber.DispatchMsg(pvMsg: PAnsiChar);
begin
  ShowMessage('TDEMOSubscriber�յ�һ����Ϣ:' + pvMsg);
end;

end.
