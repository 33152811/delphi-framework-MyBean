unit uIFrameCoreObject;

interface



type
  IFrameCoreObject = interface(IInterface)
    ['{126E2763-3AC8-495F-987E-688564190BC5}']

    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;
    
    //�Ƴ�����
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

    //�������
    procedure cleanupObjects; stdcall;


  end;

implementation

end.
