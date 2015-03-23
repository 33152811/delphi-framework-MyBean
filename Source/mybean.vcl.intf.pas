(*
 *  unit owner: D10.Mofen
 *
 *  ˵��:
 *    �õ�Ԫ����mybean��ܵĺ��ĵ�Ԫ, �ṩһЩvcl�г��õ��Ľӿ�
 *
*)
unit mybean.vcl.intf;

interface

uses
  Controls;

type
  /// <summary>
  ///   ��׼��ʾ
  /// </summary>
  IShowAsNormal = interface(IInterface)
    ['{4A2274AB-3069-4A57-879F-BA3B3D15097D}']
    procedure ShowAsNormal; stdcall;
  end;

  /// <summary>
  ///   ��ʾ��Modal����
  /// </summary>
  IShowAsModal = interface(IInterface)
    ['{6A3A6723-8FE7-4698-94BC-5CEDFD4FC750}']
    function ShowAsModal: Integer; stdcall;
  end;

  /// <summary>
  ///   ��ʾ��MDI����
  /// </summary>
  IShowAsMDI = interface(IInterface)
    ['{F68D4D30-C70C-4BCC-9F83-F50D2D873629}']
    procedure ShowAsMDI; stdcall; 
  end;

  IShowAsChild = interface(IInterface)
    ['{B0AF3A34-8A50-46F9-B723-DEE17F92633B}']
    procedure ShowAsChild(pvParent:TWinControl); stdcall;
  end;

  ILayoutInChild = interface(IInterface)
  ['{CBCB34E2-7B15-482B-BDB4-49E0802EEEDA}']
    procedure LayoutIn(pvParent:TWinControl); stdcall;
  end;


implementation

end.
