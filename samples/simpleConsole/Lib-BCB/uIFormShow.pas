unit uIFormShow;

interface

type
  /// <summary>
  ///   ��׼��ʾ
  /// </summary>
  IShowAsNormal = interface(IInterface)
    ['{4A2274AB-3069-4A57-879F-BA3B3D15097D}']
    procedure showAsNormal; stdcall;
  end;

  IXXX = interface
    ['{10000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  /// <summary>
  ///   ��ʾ��Modal����
  /// </summary>
  IShowAsModal = interface(IInterface)
    ['{6A3A6723-8FE7-4698-94BC-5CEDFD4FC750}']
    function showAsModal: Integer; stdcall;
  end;

  /// <summary>
  ///   ��ʾ��MDI����
  /// </summary>
  IShowAsMDI = interface(IInterface)
    ['{F68D4D30-C70C-4BCC-9F83-F50D2D873629}']
    procedure showAsMDI; stdcall;
  end;






implementation

end.
