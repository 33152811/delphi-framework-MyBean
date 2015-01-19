(*
 *	 Unit owner: D10.�����
 *	   blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.1  (2014-09-03 23:46:16)
 *     ��� IApplicationContextEx01�ӿ�
 *      ����ʵ���ֶ�����DLL�������ļ�
 *
 *   v0.1.0(2014-08-29 13:00)
 *     �޸ļ��ط�ʽ(beanMananger.dll-����)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *

   ���Ŀ�ܽӿ��ļ�
      IApplicationContext: ����̨����Ҫʵ�ֵĽӿ�
      IBeanFactory: �����������Ҫʵ�ֵĽӿ�
*)
unit mybean.core.intf;

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
    ///   ��ʼ�����(�̲߳���ȫ),
    ///     1.����������ļ�<ͬ����.config.ini>�������ý��г�ʼ��
    ///     2.���û�������ļ���
    ///       1>ֱ�Ӵ�(plug-ins\*.DLL, plug-ins\*.BPL, *.DLL)·���� ���� DLL��BPL�ļ��еĲ��
    ///       2>����ConfigPlugins����������ļ�
    /// </summary>
    procedure checkInitialize; stdcall;


    /// <summary>
    ///   ִ�з���ʼ���ڳ���׼���˳���ʱ��ʹ��
    /// </summary>
    procedure checkFinalize; stdcall;



    /// <summary>
    ///   ��ȡһ��bean�ӿ�(�̰߳�ȫ)
    ///     �����ʵ���ڲ���������
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   ��ȡbeanID��Ӧ�Ĺ����ӿ�
    /// </summary>
    function getBeanFactory(pvBeanID:PAnsiChar):IInterface; stdcall;
  end;

  IApplicationContextEx01 = interface(IInterface)
    ['{10009F97-1949-476D-9CE1-1AF003B47DCB}']

    /// <summary>
    ///  ���ؿ��ļ�
    /// </summary>
    /// <returns>
    ///    ���سɹ�����true, ʧ�ܷ���false, ������raiseLastOsError��ȡ�쳣
    /// </returns>
    /// <param name="pvLibFile"> (PAnsiChar) </param>
    function checkLoadLibraryFile(pvLibFile:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///    ���������ļ�
    /// </summary>
    /// <returns>
    ///   ����ʧ�ܷ���false<�ļ����ܲ�����>
    /// </returns>
    /// <param name="pvConfigFile"> (PAnsiChar) </param>
    function checkLoadBeanConfigFile(pvConfigFile:PAnsiChar): Boolean; stdcall;
  end;

  /// <summary>
  ///   ����̨��չ�ӿ�
  ///    2014-09-22 12:27:56
  /// </summary>
  IApplicationContextEx2 = interface(IInterface)
    ['{401B2E73-3C6B-4738-9DE4-B628EE5E1D44}']

    /// <summary>
    ///   ж�ص�ָ���Ĳ�������ļ�(dll)
    ///     ��ж��֮ǰӦ���ͷŵ����������Ķ���ʵ�����ͷ�����ڴ�ռ䣬
    ///     ��������˳�EXE��ʱ�򣬳����ڴ����Υ�����
    ///     ж�������������, ����false����鿴��־�ļ�
    ///     *(����ʹ��)
    /// </summary>
    function unLoadLibraryFile(pvLibFile: PAnsiChar; pvRaiseException: Boolean =
        true): Boolean; stdcall;

    /// <summary>
    ///   �ж�BeanID�Ƿ����
    /// </summary>
    function checkBeanExists(pvBeanID:PAnsiChar):Boolean; stdcall;
  end;


  /// <summary>
  ///   ����̨��չ�ӿ�
  ///     2014-11-14 12:40:17
  /// </summary>
  IApplicationContextEx3 = interface(IInterface)
    ['{4D0387BC-0FF8-4D89-B064-C8C30AA432BE}']

    /// <summary>
    ///   ��ȡ����Bean��Ϣ
    ///   result:     ���ض�ȡ�������ݳ���
    ///   pvLength:   ���Զ�ȡ�ĳ��ȣ������pvBeanInfo����������㹻���ڴ�
    ///   pvBeanInfo: ���ض�ȡ��������
    ///    utf8 AnsiString
    ///    [
    ///      {"id":"beanid", "lib":"libfile"}
    ///      ...
    ///    ]
    /// </summary>
    function GetBeanInfos(pvBeanInfo:PAnsiChar; pvLength:Integer): Integer; stdcall;
  end;



  /// <summary>
  ///   ��������ӿ�,�ɲ������(DLL, BPL)���ļ��ṩ
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// <summary>
    ///   ��ȡ���еĲ��ID
    ///     ���ػ�ȡID�ĳ��ȷָ���#10#13
    /// </summary>
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ��
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   ��ʼ��,����DLL��ִ��
    /// </summary>
    procedure checkInitalize;stdcall;

    /// <summary>
    ///   ж��DLL֮ǰִ��
    /// </summary>
    procedure checkFinalize;stdcall; 


    /// <summary>
    ///   ��������bean����ص�����,�Ḳ��֮ǰ��Bean����
    ///    pvConfig��Json��ʽ
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBeans(pvConfig:PAnsiChar):Integer; stdcall;

    /// <summary>
    ///   ����bean�������Ϣ
    ///     pvConfig��Json��ʽ�Ĳ���
    ///     �Ḳ��֮ǰ��bean����
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   ����bean����
    ///     pluginID,�ڲ��Ĳ��ID
    /// </summary>
    function configBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall; 

    /// <summary>
    ///   ����bean����
    ///     singleton,��ʵ��,
    ///     ���õ�ʵ��ʱ����ע��Ҫô�����нӿڹ����������ڣ�Ҫôʵ��IFreeObject�ӿ�
    ///     ��Ҫ�ֶ��ͷ��ͷŶ���.
    /// </summary>
    function configBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean): Integer; stdcall;
  end;

  /// <summary>
  ///   �������ע��
  /// </summary>
  IbeanFactoryRegister = interface(IInterface)
    ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   ֱ��ע��Bean�������, ��EXE����ֱ��ע��
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;
  end;


  IErrorInfo = interface(IInterface)
  ['{A15C511B-AD0A-43F9-AA3B-CAAE00DC372D}']
    /// <summary>
    ///   ��ȡ������룬û�д��󷵻� 0
    /// </summary>
    function getErrorCode: Integer; stdcall;

    /// <summary>
    ///   ��ȡ������Ϣ���ݣ����ض�ȡ���Ĵ�����Ϣ���ȣ�
    ///     ��������pvErrorDescΪnilָ�룬���ش�����Ϣ�ĳ���
    /// </summary>
    function getErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer;  stdcall;
  end;

  IFreeObject = interface
    ['{863109BC-513B-440C-A455-2AD4F5EDF508}']
    procedure FreeObject; stdcall;
  end;

  IKeyMap = interface(IInterface)
    ['{3CF4907D-C1FF-4E93-9E32-06AAD82310B4}']

    /// <summary>
    ///   �ж��Ƿ���ڽӿ�
    /// </summary>
    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    /// <summary>
    ///   ����keyֵ��ȡ�ӿ�
    /// </summary>
    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    /// <summary>
    ///  ��ֵ�ӿ�
    /// </summary>
    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   �Ƴ��ӿ�
    /// </summary>
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   �������
    /// </summary>
    procedure cleanupObjects; stdcall;

  end;

  IBeanConfigSetter = interface(IInterface)
    ['{C7DABCDB-9908-4C43-B353-647EDB7F3DCE}']


    /// <summary>
    ///   ���������е�Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   �����ļ���JSon��ʽ���ַ���
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); stdcall;
  end;



var
  appPluginContext:IApplicationContext;
  applicationKeyMap:IKeyMap;

implementation



initialization
  appPluginContext := nil;
  applicationKeyMap := nil;

finalization
  appPluginContext := nil;
  applicationKeyMap := nil;

end.
