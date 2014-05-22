unit uIBeanFactoryRegister;

interface

uses
  uIBeanFactory;

type
  /// <summary>
  ///   �������ע��, ��beanManager.dll�ṩ
  /// </summary>
  IbeanFactoryRegister = interface(IInterface)
    ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   ֱ��ע��Bean�������, ��EXE����ֱ��ע��
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;
  end;


implementation

end.
