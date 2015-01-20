(*
 * �ṩ����MyBean��ܵ�DLL���ã����г�ʼ��
 *   ��Ҫ��EXE�н���MyBean�ĳ�ʼ��(����mybeanBridgeConsole.pas)
 *     ��MyBeanBridge.dll����ע�����
 * �õ�Ԫ��ҪMyBeanBridge.dll
 *
*)

unit MyBeanBridgeLoader;

interface 

uses
  mybean.core.intf;

const
  LIB_FILE = 'MyBeanBridge.dll';

/// <summary>
///   ��ȡApplicationContext�ӿ�
/// </summary>
function GetApplicationContext: IApplicationContext; stdcall; external LIB_FILE;

/// <summary>
///   ��ȡKeyMap�ӿ�
/// </summary>
function GetApplicationKeyMap: IKeyMap; stdcall; external LIB_FILE;


implementation


initialization
  /// ��ȡDLL�ṩ�Ľӿڽ��г�ʼ��
  GetApplicationContextFunc := GetApplicationContext;
  GetApplicationKeyMapFunc := GetApplicationKeyMap;

end.
