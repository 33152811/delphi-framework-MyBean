#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"
#include "BeanFactory.h"

/// ȫ�ֵĲ����������
BeanFactory * __beanFactory;

/// ȫ�ֵ�ApplicationContext
IInterface * __applicationContext;


IInterface * __stdcall GetBean(PMyBeanChar beanID){
	IApplicationContextForCPlus * applicationContext;
	IInterface * ret;
	const GUID intfIID = __uuidof(IApplicationContextForCPlus);
	if (__applicationContext->QueryInterface(intfIID, (void**)&applicationContext) == S_OK)
	{
		applicationContext->GetBeanForCPlus(beanID, (IInterface**)&ret);			
		applicationContext->Release();  // QueryInterface��Delphi�н������ۼ�, ������ɺ� ���м�������
		return ret;
	}
	else
	{
		return NULL;
	}
}