unit uIBeanFactory;

interface



type

  /// <summary>
  ///   �������
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// ��ȡ���еĲ��ID
    function getBeanList: PAnsiChar; stdcall;

    /// ����һ�����
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;

implementation

end.
