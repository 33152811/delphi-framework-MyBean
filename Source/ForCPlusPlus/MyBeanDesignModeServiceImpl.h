#if _MSC_VER > 1000
#pragma once
#endif 

#include "MyBeanDesignMode.h"




/// ȫ�ֵĲ�����̱�������
/// <summary>
///   ��ȡһ�������߽ӿ�ʵ��
/// </summary>
IPublisher * GetPublisher(PMyBeanChar publisherId)
{
	
	IInterface * intf = GetBean("MyBeanSubscribeCenter");
	ISubscribeCenter * subscribeCenter = NULL;
	IPublisher * publisher = NULL;
	if (intf != NULL)
	{
		if (intf->QueryInterface(__uuidof(ISubscribeCenter), (void**)&subscribeCenter) == S_OK)
		{
			intf->Release();	
			subscribeCenter->GetPublisher(publisherId, (IPublisher**)&publisher);
			subscribeCenter->Release();
			return publisher;
		}
		else
		{
			intf->Release();
			return NULL;
		}
	}
}

/// <summary>
///   �򷢲������һ��������
/// </summary>
bool AddSubscriber(PMyBeanChar publisherId, IInterface * subscriber)
{
	IPublisher * publisher = GetPublisher(publisherId);
	if (publisher != NULL)
	{
		publisher->AddSubscriber(subscriber);
		publisher->Release();
		return true;
	}
	else
	{
		return false;
	}
}