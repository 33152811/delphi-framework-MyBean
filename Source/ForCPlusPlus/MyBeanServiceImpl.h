#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"
#include "BeanFactory.h"

/// ȫ�ֵĲ����������
BeanFactory * __beanFactory;

/// ȫ�ֵ�ApplicationContext
IInterface * __applicationContext;

/// ��ȡApplicationContext�ӿ�
TGetInterfaceFunctionForStdcall __ApplicationContextGetter;

/// ��ȡApplicationKeyMap�ӿ�
TGetInterfaceFunctionForStdcall __ApplicationMapGetter;


IStrMapForCPlus * GetApplicationMap()
{
	if (__ApplicationMapGetter == NULL)
	{
		return NULL;
	}
	else
	{
		IInterface * map;
		__ApplicationMapGetter(&map);
		if (map == NULL){ 
			return NULL; 
		}
		else{			
			IStrMapForCPlus * ret= NULL;
			OutputDebugStringA("Map->QueryInterfaced(IStrMapForCPlus)\r\n");
			if (map->QueryInterface(__uuidof(IStrMapForCPlus), (void**)&ret) == S_OK)
			{
				map->Release();
				return ret;
			}
			else
			{
				map->Release();
				return NULL;
			}
		}
	}
}

IInterface * GetMapObject(PMyBeanChar objId)
{
	IStrMapForCPlus * map = GetApplicationMap();
	if (map != NULL)
	{	
		IInterface * ret;
		map->GetValue(objId, &ret);
		map->Release();
		return ret;
	}
	else
	{
		return NULL;
	}
}


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

