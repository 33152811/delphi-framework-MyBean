unit uIRemoteFileAccess;

interface

type
  /// <summary>
  ///   Զ���ļ��洢�ӿ�
  /// </summary>
  IRemoteFileAccess = interface(IInterface)
    ['{7F33D84A-5D10-40E7-A0D0-5519F8743BFC}']

    /// <summary>
    ///   �ϴ��ļ�
    /// </summary>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    procedure UploadFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    /// <summary>
    ///   ɾ���ļ�
    /// </summary>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    procedure DeleteFile(pvRFileName, pvType: PAnsiChar);

    /// <summary>
    ///   �����ļ�
    /// </summary>
    /// <returns>
    ///   ���سɹ�����True
    /// </returns>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    function DownFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar): Boolean;


    /// <summary>
    ///   ��ȡԶ���ļ���С
    /// </summary>
    function FileSize(pvRFileName, pvType: PAnsiChar): Int64;
  end;

  IRemoteConnector = interface(IInterface)
    ['{ABDDE5A3-4E88-4006-99E1-47E16C86DEC5}']
    procedure SetHost(pvHost:PAnsiChar); stdcall;
    procedure SetPort(pvPort:Integer); stdcall;

    procedure Open;stdcall;
    procedure Close;stdcall;
  end;

  

implementation

end.
