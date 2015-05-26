#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"

/// <summary>
///   ����������
/// </summary>
/// ISubscribeListener = interface
/// ['{ECC2BDC4-737E-4493-BFF1-DCC7B5CE0BD8}']
interface DECLSPEC_UUID("{ECC2BDC4-737E-4493-BFF1-DCC7B5CE0BD8}")
ISubscribeListener: public IInterface{

/// <summary>
///   �����һ��������
/// </summary>
/// <param name="pvSubscriberID"> ������ID </param>
/// <param name="pvSubscriber"> ������ </param>
/// procedure OnAddSubscriber(pvSubscriberID: Integer; const pvSubscriber : IInterface); stdcall;
virtual void __stdcall OnAddSubscriber(int index, const IInterface * subscriber) = 0;


/// <summary>
///   �Ƴ���һ��������
/// </summary>
/// <param name="pvSubscriberID"> ������ID </param>
/// procedure OnRemoveSubscriber(pvSubscriberID: Integer); stdcall;
virtual void __stdcall OnRemoveSubscriber(int subscriberId) = 0;
};


/// <summary>
///   �����߽ӿ�
/// </summary>
///IPublisher = interface
///['{AF590D7D-2E86-4729-8282-0423781EBB4C}']
interface DECLSPEC_UUID("{AF590D7D-2E86-4729-8282-0423781EBB4C}")
IPublisher: public IInterface{

/// <summary>
///   ע��һ�������ߵ�������ʵ����
/// </summary>
/// <returns>
///   ����һ��ID,�Ƴ�ʱͨ����ID�����Ƴ�, ע��ʧ�ܷ���-1
/// </returns>
/// <param name="pvSubscriber"> (IInterface) </param>
/// function AddSubscriber(const pvSubscriber : IInterface) : Integer; stdcall;
virtual int __stdcall AddSubscriber(const IInterface *p) = 0;

/// <summary>
///   �ӷ��������Ƴ���һ��������
/// </summary>
/// <returns>
///   �ɹ�����True, ʧ�ܷ���:False
/// </returns>
/// <param name="pvSubscriberID"> ������ID(���ʱ���ص�ID) </param>
/// function RemoveSubscriber(pvSubscriberID: Integer) : HRESULT; stdcall;
virtual HRESULT __stdcall RemoveSubscriber(int subscriberId) = 0;


/// <summary>
///   ��ȡ����������
/// </summary>
/// <returns>
///   ����
/// </returns>
/// function GetSubscriberCount : Integer; stdcall;
virtual int __stdcall GetSubscriberCount() = 0;


/// <summary>
///   ��ȡ���е�һ��������
/// </summary>
/// <returns>
///   S_OK,��ȡ�ɹ�
/// </returns>
/// <param name="pvIndex">  ��� </param>
/// <param name="vSubscribeInstance"> ���صĶ����� </param>
/// function GetSubscriber(pvIndex: Integer; out vSubscribeInstance : IInterface) :HRESULT; stdcall;
virtual HRESULT __stdcall GetSubscriber(int index, IInterface ** vSubscribeInstance) = 0;


/// <summary>
///   �����һ������������
///   ��ӻ����Ƴ�������ʱ����֪ͨ
/// </summary>
/// <returns>
///   S_OK: �ɹ�
/// </returns>
/// <param name="pvInstance"> ���������� </param>
/// function AddSubscribeListener(const pvInstance : ISubscribeListener) : HRESULT; stdcall;
virtual HRESULT __stdcall AddSubscribeListener(const ISubscribeListener * p) = 0;

/// <summary>
///   �Ƴ�һ������������
/// </summary>
/// <returns> S_OK: �ɹ�
/// </returns>
/// <param name="pvInstance"> (ISubscribeListener) </param>
/// function RemoveSubscribeListener(const pvInstance : ISubscribeListener) : HRESULT; stdcall;
virtual HRESULT __stdcall RemoveSubscribeListener(const ISubscribeListener * p) = 0;
};

/// <summary>
///   MyBean ����ģʽ����
/// </summary>
/// ISubscribeCenter = interface
//  ['{805F8214-6766-4A51-9CD8-09BE67B8D383}']
interface DECLSPEC_UUID("{805F8214-6766-4A51-9CD8-09BE67B8D383}")
ISubscribeCenter: public IInterface{

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
///  function GetPublisher(pvPublisherID:PMyBeanChar; out vPubInstance : IPublisher) : HRESULT;  stdcall;
virtual HRESULT __stdcall GetPublisher(PMyBeanChar publisherId, IPublisher **p) = 0;
};


/// <summary>
///   ��ȡһ�������߽ӿ�ʵ��
/// </summary>
extern IPublisher * GetPublisher(PMyBeanChar publisherId);

/// <summary>
///   �򷢲������һ��������
/// </summary>
extern void AddSubscriber(PMyBeanChar publisherId, IInterface * subscriber);