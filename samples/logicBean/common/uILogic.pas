unit uILogic;

interface



type
  /// <summary>
  ///   �ϼƲ���ӿ�
  /// </summary>
  ISumExp = interface(IInterface)
    ['{D02C3764-1231-46EC-8C74-95DFBF2A1ED5}']
    function sum(i:Integer; j:Integer):Integer; stdcall;
  end;

  /// <summary>
  ///   ��־����ӿ�
  /// </summary>
  IMyBeanLogger = interface(IInterface)
    ['{B872909D-99FF-47B9-A3F9-8CB9C26A8FD5}']
    procedure LogMessage(s: PAnsiChar); stdcall;
  end;

implementation

end.
