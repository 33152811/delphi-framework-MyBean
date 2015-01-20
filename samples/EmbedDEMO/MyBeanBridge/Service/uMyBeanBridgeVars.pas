unit uMyBeanBridgeVars;

interface

uses
  mybean.core.intf;


type
  LPFN_CONTEXT_GETTER = function:IApplicationContext; stdcall;
  LPFN_KEYMAP_GETTER = function:IKeyMap; stdcall;

/// <summary>
///   ��ȡApplicationContext�ӿ�
/// </summary>
function GetApplicationContext: IApplicationContext; stdcall;

/// <summary>
///   ��ȡKeyMap�ӿ�
/// </summary>
function GetApplicationKeyMap: IKeyMap; stdcall;

/// <summary>
///   ע��һ��ApplicationiContext����������̨��ʼ��ʱ��������
/// </summary>
procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER); stdcall;

/// <summary>
///   ����ApplicationContext����������̨�˳�ʱִ�У��ͷ�ApplicationContext������
/// </summary>
procedure UnRegisterObject; stdcall;

implementation

exports
   GetApplicationContext, GetApplicationKeyMap, RegisterObject, UnRegisterObject;



var
  /// <summary>
  ///   �ṩһ����ȡappPluginContext����ĺ���ָ��
  /// </summary>
  InnerContextGetterFunc: LPFN_CONTEXT_GETTER;

  /// <summary>
  ///   �ṩһ����ȡapplicationKeyMap����ĺ���ָ��
  /// </summary>
  InnerKeyMapGetterFunc: LPFN_KEYMAP_GETTER;


function GetApplicationContext: IApplicationContext;
begin
  Result := InnerContextGetterFunc();
end;

function GetApplicationKeyMap: IKeyMap;
begin
  Result := InnerKeyMapGetterFunc();
end;

procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER);
begin
  InnerContextGetterFunc := pvContextGetter;
  InnerKeyMapGetterFunc := pvKeyMapGetter;
end;

procedure UnRegisterObject;
begin
  InnerContextGetterFunc := nil;
  InnerKeyMapGetterFunc := nil;
end;



end.
