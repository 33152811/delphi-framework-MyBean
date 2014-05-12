unit uIUIChild;

interface

uses
  Controls;



type
  IUIChild = interface(IInterface)
    ['{E0F2D5D4-D925-4E4E-AC75-7BA93A5C26BC}']

    //�ͷ�Frame
    procedure UIFree; stdcall;

    //��ȡ�������
    function getObject:TWinControl; stdcall;

    //��ȡʵ��ID
    function getInstanceID: Integer; stdcall;

    //������һ��Parent����
    procedure ExecuteLayout(pvParent:TWinControl); stdcall;

    function getInstanceName: string; stdcall;
    procedure setInstanceName(const pvValue: string); stdcall;

    property InstanceName: string read GetInstanceName write SetInstanceName;


  end;

implementation

end.
