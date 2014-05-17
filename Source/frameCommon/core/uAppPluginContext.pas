unit uAppPluginContext;

interface

uses
  uIAppliationContext, uIBeanFactory, uIKeyMap;


/// <summary>
///   ��ȡIApplictionContext�ӿ�, ��beanMananger�ṩ����ʵ��
///     ���𴴽��͹���bean
/// </summary>
function appPluginContext: IApplicationContext; stdcall; external
    'beanManager.dll';

/// <summary>
///    ִ��������
///     ��app�˳���ʱ�����
/// </summary>
procedure appContextCleanup; stdcall; external 'beanManager.dll';

/// <summary>
///   ע��beanFactory��appPluginContext�У�
///     ������û�е�DLL�����Ҳ����ʹ�ò������
/// </summary>
function registerFactoryObject(const pvBeanFactory:IBeanFactory;
  const pvNameSapce:PAnsiChar): Integer; stdcall; external 'beanManager.dll';


/// <summary>
///   ��ȡȫ�ֵ�KeyMap�ӿ�
/// </summary>
function applicationKeyMap: IKeyMap; stdcall; external 'beanManager.dll';


/// <summary>
///   ��������ã���������������,��װ�ɺ������ñ�����ʱ���ýӿ�
/// </summary>
procedure applicationContextIntialize;

/// <summary>
///   ��������ã���������������,��װ�ɺ������ñ�����ʱ���ýӿ�
/// </summary>
procedure applicationContextFinalize;

implementation

procedure applicationContextIntialize;
begin
  appPluginContext.checkInitialize();
end;

procedure applicationContextFinalize;
var
  lvIntf:IApplicationContext;
begin
  lvIntf := appPluginContext;
  lvIntf.checkFinalize;
  lvIntf := nil;
  appContextCleanup;
end;


end.
