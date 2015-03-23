(*
   ���FileAccessEX�ӿ�
     2014-09-16 15:25:24
*)
unit uIFileAccess;

interface

type
  //�ļ��洢�ӿ�
  IFileAccess = interface(IInterface)
    ['{C69EC3FB-0248-4C54-80CB-6DC11E85C66A}']

    /// <summary>
    ///   �����ļ�
    /// </summary>
    /// <param name="pvRFileName"> �ļ�ID </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    procedure saveFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    //ɾ���ļ�
    procedure deleteFile(pvRFileName, pvType: PAnsiChar);

    /// <summary>
    ///   ��ȡ�ļ�
    /// </summary>
    /// <returns>
    ///   ��ȡ�ɹ���
    /// </returns>
    /// <param name="pvRFileName"> �ļ�ID </param>
    /// <param name="pvLocalFileName"> ��ȡ�����󱣴��ڱ����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    /// <param name="pvRaiseIfFalse"> �Ƿ�Raise���� </param>
    function getFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar;
        pvRaiseIfFalse: Boolean = true): Boolean;
  end;

  IFileAccessSetter = interface(IInterface)
    ['{F00482DA-9B44-4215-99F6-FD2E7BBC853D}']
    procedure setFileAcccess(const pvFileAccess: IFileAccess); stdcall;
  end;

  IFileAccessEx = interface(IInterface)
    ['{FF76603C-1FFF-4985-88D3-16BCE2066B01}']
    
    /// <summary>
    ///   COPY�ļ�
    /// </summary>
    /// <param name="pvRSourceFileName"> Զ��Դ�ļ� </param>
    /// <param name="pvLocalFileName"> Զ��Ŀ���ļ� </param>
    /// <param name="pvType"> ���� </param>
    procedure copyAFile(pvRSourceFileName, pvRDestFileName, pvType: PAnsiChar);
  end;

  IFileAccess02 = interface(IInterface)
    ['{BE9ED805-E022-41F6-9E01-FE619CFE3CA3}']

    /// <summary>
    ///   ��ȡԶ���ļ���С
    /// </summary>
    function FileSize(pvRFileName, pvType: PAnsiChar): Int64;
  end;
implementation

end.
