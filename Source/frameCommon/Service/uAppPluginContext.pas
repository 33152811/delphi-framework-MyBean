unit uAppPluginContext;

interface

uses
  uIAppliationContext, uIBeanFactory;


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

implementation


end.
