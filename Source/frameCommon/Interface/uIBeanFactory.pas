unit uIBeanFactory;

interface



type

  /// <summary>
  ///   �������
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// <summary>
    ///   ��ȡ���еĲ��ID
    ///     ���ػ�ȡID�ĳ��ȷָ���#10#13
    /// </summary>
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// ����һ�����
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;


implementation

end.
