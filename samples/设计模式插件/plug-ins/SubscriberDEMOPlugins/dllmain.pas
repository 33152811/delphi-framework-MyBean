unit dllmain;

interface

uses
  mybean.ex.designmode.utils;

type
  PInterface = ^IInterface;
  TGetInterfaceFunctionForStdcall = function(pvIntf:PInterface):HRESULT; stdcall;

/// <summary>
///   ������DLL�Ѿ�ȫ���������, ׼������Ӧ�ó����ʱ��,
///   ��Ҫ��EXE��ִ��mybean.console��Ԫ�е�StartLibraryService����
/// </summary>
procedure StartLibraryService; stdcall;

implementation

uses
  uDEMOImpl;

procedure StartLibraryService; stdcall;
begin
  // ��testerʵ�ж���
  GetPublisher('tester').AddSubscriber(TDEMOSubscriber.Create);     
end;

exports
  StartLibraryService;



end.
