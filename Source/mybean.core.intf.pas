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
  IBeanFactory = interface;
  /// <summary>
  ///   �ӿ��Ѿ��ı���Ҫ���±������е�DLL������̨
  ///     2014��5��15�� 20:55:28
  ///     D10.�����
  ///     ����� CheckFinalize
  ///     �޸��� CheckInitialize(pvLoadLib:Boolean);stdcall; ����˲���
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
    procedure CheckInitialize; stdcall;


    /// <summary>
    ///   ִ�з���ʼ���ڳ���׼���˳���ʱ��ʹ��
    /// </summary>
    procedure CheckFinalize; stdcall;



    /// <summary>
    ///   ��ȡһ��bean�ӿ�(�̰߳�ȫ)
    ///     �����ʵ���ڲ���������
    /// </summary>
    function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   ��ȡbeanID��Ӧ�Ĺ����ӿ�
    /// </summary>
    function GetBeanFactory(pvBeanID:PAnsiChar): IInterface; stdcall;
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
    function CheckLoadLibraryFile(pvLibFile:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///   �������ļ��м���, ���سɹ������Bean��������
    ///   ���Ե��ö��
    /// </summary>
    /// <returns>
    ///   ����ʧ�ܷ���false<�ļ����ܲ�����>
    /// </returns>
    /// <param name="pvConfigFile">
    ///     pvConfigFiles,�����ļ�ͨ���"*.plug-ins, *.config"
    ///     ������ָ�����ͨ����ļ�
    ///     ��Ӧ���ļ�������json�ļ���������������
    /// </param>
    function CheckLoadBeanConfigFile(pvConfigFile:PAnsiChar): Boolean; stdcall;
  end;

  /// <summary>
  ///   C++ ���Ե��õĽӿ�
  /// </summary>
  IApplicationContextForCPlus = interface
    ['{9A7238C4-5A47-494B-9058-77500C1622DC}']

    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ��
    /// </summary>
    function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;

    /// <summary>
    ///   ��ȡbeanID��Ӧ�Ĺ����ӿ�
    /// </summary>
    function GetBeanFactoryForCPlus(pvBeanID:PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;
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
    function UnLoadLibraryFile(pvLibFile: PAnsiChar; pvRaiseException: Boolean =
        true): Boolean; stdcall;

    /// <summary>
    ///   �ж�BeanID�Ƿ����
    /// </summary>
    function CheckBeanExists(pvBeanID:PAnsiChar): Boolean; stdcall;
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

    /// <summary>
    ///    ����һ�����ļ�, ��ȡ���в����������ע��
    ///    ���سɹ������Ѿ����ط���Lib�ļ��е�BeanFactory�ӿ�
    ///    ʧ�ܷ���nil
    /// </summary>
    function CheckLoadALibFile(pvFile: PAnsiChar): IBeanFactory; stdcall;

//
//    /// <summary>
//    ///   ���һ�����ʵ��, ������GetBean���л�ȡ
//    /// </summary>
//    /// <param name="pvPluginID"> �����ID, ���֮ǰ����ӣ����ᱻ�滻�����һ����ӵ� </param>
//    /// <param name="pvPlugin"> ���ʵ�� </param>
//    procedure AddPlugin(pvPluginID:PAnsiChar; pvPlugin:IInterface); stdcall;
//
//    /// <summary>
//    ///   �Ƴ���һ�����ʵ��.
//    /// </summary>
//    /// <param name="pvPluginID"> ���ʱ�Ĳ��ID </param>
//    procedure RemovePlugin(pvPluginID:PAnsiChar); stdcall;
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
    function GetBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ��
    /// </summary>
    function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   ��ʼ��,����DLL��ִ��
    /// </summary>
    procedure CheckInitalize; stdcall;

    /// <summary>
    ///   ж��DLL֮ǰִ��
    /// </summary>
    procedure CheckFinalize; stdcall;


    /// <summary>
    ///   ��������bean����ص�����,�Ḳ��֮ǰ��Bean����
    ///    pvConfig��Json��ʽ
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function ConfigBeans(pvConfig:PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   ����bean�������Ϣ
    ///     pvConfig��Json��ʽ�Ĳ���
    ///     �Ḳ��֮ǰ��bean����
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function ConfigBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   ����bean����
    ///     pluginID,�ڲ��Ĳ��ID
    /// </summary>
    function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   ����bean����
    ///     singleton,��ʵ��,
    ///     ���õ�ʵ��ʱ����ע��Ҫô�����нӿڹ����������ڣ�Ҫôʵ��IFreeObject�ӿ�
    ///     ��Ҫ�ֶ��ͷ��ͷŶ���.
    /// </summary>
    function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean):
        Integer; stdcall;
  end;

/// <summary>
  ///   VC �ӿ�
  /// </summary>
  IBeanFactoryForCPlus = interface
    ['{D6F1B138-ECEA-44FC-A3E3-0B5169F1077A}']
    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ��
    /// </summary>
    function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;
  end;

  /// <summary>
  ///   �������ע��
  /// </summary>
  IBeanFactoryRegister = interface(IInterface)
  ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   ֱ��ע��Bean�������, ��EXE����ֱ��ע��
    /// </summary>
    function RegisterBeanFactory(const pvFactory: IBeanFactory; const
        pvNameSapce:PAnsiChar): Integer; stdcall;
  end;


  IErrorInfo = interface(IInterface)
  ['{A15C511B-AD0A-43F9-AA3B-CAAE00DC372D}']
    /// <summary>
    ///   ��ȡ������룬û�д��󷵻� 0
    /// </summary>
    function GetErrorCode: Integer; stdcall;

    /// <summary>
    ///   ��ȡ������Ϣ���ݣ����ض�ȡ���Ĵ�����Ϣ���ȣ�
    ///     ��������pvErrorDescΪnilָ�룬���ش�����Ϣ�ĳ���
    /// </summary>
    function GetErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer;
        stdcall;
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
    function ExistsObject(const pvKey:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///   ����keyֵ��ȡ�ӿ�
    /// </summary>
    function GetObject(const pvKey:PAnsiChar): IInterface; stdcall;

    /// <summary>
    ///  ��ֵ�ӿ�
    /// </summary>
    procedure SetObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   �Ƴ��ӿ�
    /// </summary>
    procedure RemoveObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   �������
    /// </summary>
    procedure CleanupObjects; stdcall;

  end;

  IBeanConfigSetter = interface(IInterface)
    ['{C7DABCDB-9908-4C43-B353-647EDB7F3DCE}']


    /// <summary>
    ///   ���������е�Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   �����ļ���JSon��ʽ���ַ���
    /// </param>
    procedure SetBeanConfig(pvBeanConfig: PAnsiChar); stdcall;
  end;



var

  appPluginContext:IApplicationContext;
  applicationKeyMap:IKeyMap;

  /// <summary>
  ///   �ṩһ����ȡappPluginContext����ĺ���ָ�룬TMyBeanFactoryTools�������ָ����ڣ�ֱ�ӵ��øú���
  /// </summary>
  GetApplicationContextFunc: function:IApplicationContext; stdcall;

  /// <summary>
  ///   �ṩһ����ȡapplicationKeyMap����ĺ���ָ�룬TMyBeanFactoryTools�������ָ����ڣ�ֱ�ӵ��øú���
  /// </summary>
  GetApplicationKeyMapFunc: function:IKeyMap; stdcall;
  

implementation



initialization
  appPluginContext := nil;
  applicationKeyMap := nil;

finalization
  appPluginContext := nil;
  applicationKeyMap := nil;

end.
