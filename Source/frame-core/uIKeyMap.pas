unit uIKeyMap;

interface



type
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

implementation

end.
