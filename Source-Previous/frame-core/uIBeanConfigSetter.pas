unit uIBeanConfigSetter;

interface



type
  IBeanConfigSetter = interface(IInterface)
    ['{C7DABCDB-9908-4C43-B353-647EDB7F3DCE}']


    /// <summary>
    ///   ���������е�Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   �����ļ���JSon��ʽ���ַ���
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); stdcall;
  end;

implementation

end.
