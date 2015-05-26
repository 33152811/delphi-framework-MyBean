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
	IPublisher * publisher = NULL;
	if (intf != NULL)
	{
		if (intf->QueryInterface(__uuidof(IPublisher), (void**)&publisher) == S_OK)
		{
			intf->Release();			
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
		publisher -> 
		return true;
	}
	else
	{
		return false;
	}
}