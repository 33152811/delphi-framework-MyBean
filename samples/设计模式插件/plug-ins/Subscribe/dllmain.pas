unit dllmain;

interface

type
  PInterface = ^IInterface;
  TGetInterfaceFunctionForStdcall = function(pvIntf:PInterface):HRESULT; stdcall;

/// <summary>
///   ������DLL�Ѿ�ȫ���������, ׼������Ӧ�ó����ʱ��, ��Ҫ��EXE��ִ��mybean.console��Ԫ�е�StartLibraryService����
/// </summary>
procedure StartLibraryService; stdcall;

implementation

procedure StartLibraryService; stdcall;
begin
   
end;

exports
  StartLibraryService;



end.
