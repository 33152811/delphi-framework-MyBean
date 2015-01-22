(*
 * �ṩ����MyBean���ʹ�ã����г�ʼ��
 *   ��MyBeanBridge.dll�еĻ�ȡ��ַ�����Ž�
*)

unit mybean.tools.bridgeConsole;

interface 

uses
  mybean.core.intf;

const
  LIB_FILE = 'MyBeanBridge.dll';

type
  LPFN_CONTEXT_GETTER = function:IApplicationContext; stdcall;
  LPFN_KEYMAP_GETTER = function:IKeyMap; stdcall;

/// <summary>
///   ע��һ��ApplicationiContext����������̨��ʼ��ʱ��������
/// </summary>
procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER); stdcall; external LIB_FILE;

/// <summary>
///   ����ApplicationContext����������̨�˳�ʱִ�У��ͷ�ApplicationContext������
/// </summary>
procedure UnRegisterObject; stdcall; external LIB_FILE;



implementation


function ConsoleContextGetter:IApplicationContext; stdcall;
begin
  Result := mybean.core.intf.appPluginContext;
end;

function ConsoleMapGetter:IKeyMap; stdcall;
begin
  Result := mybean.core.intf.applicationKeyMap;
end;


initialization
  RegisterObject(ConsoleContextGetter, ConsoleMapGetter);


finalization
  UnRegisterObject();

end.
