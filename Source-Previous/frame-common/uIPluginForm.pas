unit uIPluginForm;

interface 

type 
  /// <summary>
  ///   ����������
  /// </summary>
  IPluginForm = interface(IInterface)
    ['{27DDB6A4-7D2F-4026-AA95-EBB995E573AC}']

    /// <summary>
    ///   MDI��ʽ��ʾ����
    /// </summary>
    procedure showAsMDI; stdcall;

    /// <summary>
    ///   showModal��ʽ��ʾ����
    /// </summary>
    function showAsModal: Integer; stdcall;

    /// <summary>
    ///   ��ʾ����
    /// </summary>
    procedure showAsNormal(); stdcall;

    /// <summary>
    ///   �رմ���
    /// </summary>
    procedure closeForm; stdcall;

    /// <summary>
    ///   �ͷŴ���
    /// </summary>
    procedure freeObject; stdcall;

    /// <summary>
    ///   ��ȡ�������
    /// </summary>
    function getObject:TObject; stdcall;

    /// <summary>
    ///   ��ȡ����ΨһID, �ɴ��崴��ʱ�������
    /// </summary>
    function getInstanceID: string; stdcall;

  end;

implementation

end.
