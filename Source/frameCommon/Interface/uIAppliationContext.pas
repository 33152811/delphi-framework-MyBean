unit uIAppliationContext;

interface


type
  /// <summary>
  ///   �ӿ��Ѿ��ı���Ҫ���±������е�DLL������̨
  ///     2014��5��15�� 20:55:28
  ///     D10.�����
  ///     ����� checkFinalize
  ///     �޸��� checkInitialize(pvLoadLib:Boolean);stdcall; ����˲���
  /// </summary>
  IApplicationContext = interface(IInterface)
    ['{0FE2FD2D-3A21-475B-B51D-154E1728893B}']

    /// <summary>
    ///   ��ʼ������(�̲߳���ȫ),
    ///      pvLoadLibΪtrueʱ���������ļ���ͬʱ����DLL�ļ�(����˳����Ƽ�)
    ///               Ϊflaseʱֻ���������ļ�(�ͻ��˳����Ƽ�)
    /// </summary>
    procedure checkInitialize(pvLoadLib:Boolean);stdcall;


    /// <summary>
    ///   ִ�з���ʼ���ڳ���׼���˳���ʱ��ʹ��
    /// </summary>
    procedure checkFinalize; stdcall;



    /// <summary>
    ///   ��ȡһ��bean�ӿ�(�̰߳�ȫ)
    ///     �����ʵ���ڲ���������
    /// </summary>
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;

implementation

end.
