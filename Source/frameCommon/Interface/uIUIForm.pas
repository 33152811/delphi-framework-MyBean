unit uIUIForm;

interface 

type 
  /// <summary>
  ///   ������
  /// </summary>
  IUIForm = interface(IInterface)
    ['{7E250C3C-331E-4732-AD05-F08CA1CA486A}']
    procedure showAsMDI; stdcall;

    function showAsModal: Integer; stdcall;

    //�ر�
    procedure UIFormClose; stdcall;

    //�ͷŴ���
    procedure UIFormFree; stdcall;

    //��ȡ�������
    function getObject:TObject; stdcall;

    //��ȡʵ��ID
    function getInstanceID: Integer; stdcall;
  end;

implementation

end.
