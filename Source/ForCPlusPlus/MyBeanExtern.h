#if _MSC_VER > 1000
#pragma once
#endif 

/// ȫ�ֵĲ�����̱�������
extern BeanFactory * __beanFactory;
extern IInterface * __applicationContext;
extern IInterface * __stdcall GetBean(PMyBeanChar beanID);
extern IInterface * GetMapObject(PMyBeanChar objId);