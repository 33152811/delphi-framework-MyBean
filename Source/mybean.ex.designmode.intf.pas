unit mybean.ex.designmode.intf;

interface

uses
  mybean.core.intf;

type
  IPublisher = interface;
  
  /// <summary>
  ///   MyBean ����ģʽ����
  /// </summary>
  ISubscribeCenter = interface
    ['{805F8214-6766-4A51-9CD8-09BE67B8D383}']

    /// <summary>
    ///   ͨ��������ID��ȡһ�������߽ӿ�ʵ��, �����ʵ������������д���������ֱ�ӷ���
    ///   �̰߳�ȫ�汾(
    /// </summary>
    /// <returns>
    ///   S_OK����ȡ�ɹ�
    ///   S_FALSE: ��ȡʧ��
    /// </returns>
    /// <param name="pvPublisherID"> ͬһ��pvPublisherID��ȡ�ķ�����ʵ������ͬ�� </param>
    /// <param name="vPubInstance"> ���صĽӿ�ʵ�� </param>
    function GetPublisher(pvPublisherID:PMyBeanChar; out vPubInstance:IPublisher): HRESULT;  stdcall;

  end;

  /// <summary>
  ///   ����������
  /// </summary>
  ISubscribeListener = interface
    ['{ECC2BDC4-737E-4493-BFF1-DCC7B5CE0BD8}']

    /// <summary>
    ///   �����һ��������
    /// </summary>
    /// <param name="pvSubscriberID"> ������ID </param>
    /// <param name="pvSubscriber"> ������ </param>
    procedure OnAddSubscriber(pvSubscriberID: Integer; const pvSubscriber:
        IInterface); stdcall;

    /// <summary>
    ///   �Ƴ���һ��������
    /// </summary>
    /// <param name="pvSubscriberID"> ������ID </param>
    procedure OnRemoveSubscriber(pvSubscriberID: Integer); stdcall;
  end;


  /// <summary>
  ///   �����߽ӿ�
  /// </summary>
  IPublisher = interface
    ['{AF590D7D-2E86-4729-8282-0423781EBB4C}']

    /// <summary>
    ///   ע��һ�������ߵ�������ʵ����
    /// </summary>
    /// <returns>
    ///   ����һ��ID,�Ƴ�ʱͨ����ID�����Ƴ�, ע��ʧ�ܷ���-1
    /// </returns>
    /// <param name="pvSubscriber"> (IInterface) </param>
    function AddSubscriber(const pvSubscriber: IInterface): Integer; stdcall;

    /// <summary>
    ///   �ӷ��������Ƴ���һ��������
    /// </summary>
    /// <returns>
    ///   �ɹ�����True, ʧ�ܷ���:False
    /// </returns>
    /// <param name="pvSubscriberID"> ������ID(���ʱ���ص�ID) </param>
    function RemoveSubscriber(pvSubscriberID: Integer): HRESULT; stdcall;


    /// <summary>
    ///   ��ȡ����������
    /// </summary>
    /// <returns>
    ///   ����
    /// </returns>
    function GetSubscriberCount: Integer; stdcall;


    /// <summary>
    ///   ��ȡ���е�һ��������
    /// </summary>
    /// <returns>
    ///   S_OK,��ȡ�ɹ�
    /// </returns>
    /// <param name="pvIndex">  ��� </param>
    /// <param name="vSubscribeInstance"> ���صĶ����� </param>
    function GetSubscriber(pvIndex: Integer; out vSubscribeInstance: IInterface):
        HRESULT; stdcall;


    /// <summary>
    ///   �����һ������������
    ///   ��ӻ����Ƴ�������ʱ����֪ͨ
    /// </summary>
    /// <returns>
    ///   S_OK: �ɹ�
    /// </returns>
    /// <param name="pvInstance"> ���������� </param>
    function AddSubscribeListener(const pvInstance: ISubscribeListener): HRESULT;
        stdcall;

    /// <summary>
    ///   �Ƴ�һ������������
    /// </summary>
    /// <returns> S_OK: �ɹ�
    /// </returns>
    /// <param name="pvInstance"> (ISubscribeListener) </param>
    function RemoveSubscribeListener(const pvInstance: ISubscribeListener):
        HRESULT; stdcall;
  end;




implementation

end.
