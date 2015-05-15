#if _MSC_VER > 1000
#pragma once
#endif 

#include "MyBeanInterfaceForCPlus.h"
#include <map>
#include <string>

using namespace std;

/// �����������
typedef void(*CreateInstanceMethod)(IInterface ** instance);



class BeanInfo
{
private:
	IInterface * instance;
public:
	BeanInfo();
	~BeanInfo();
	string beanid;
	CreateInstanceMethod createMethod;
};

class BeanFactory :public IBeanFactory, IBeanFactory4CPlus
{
private:
	long m_ref;
	map<string, BeanInfo *> beanInfoList;
	void ClearBeanInfoList();
public:
	BeanFactory();
	~BeanFactory();
	HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppv);
	ULONG STDMETHODCALLTYPE AddRef();
	ULONG STDMETHODCALLTYPE Release();

	BeanInfo * RegisterBean(string beanid, CreateInstanceMethod method);
public:
	/// <summary>
	///   ��ȡ���еĲ��ID
	///     ���ػ�ȡID�ĳ��ȷָ���#10#13
	/// </summary>
	int __stdcall GetBeanList(PMyBeanChar IDs, int len);

	/// <summary>
	///   ����beanID��ȡ��Ӧ�Ĳ��
	/// </summary>
	///  function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;
	HRESULT __stdcall GetBean(PMyBeanChar beanId);

	/// <summary>
	///   ����beanID��ȡ��Ӧ�Ĳ��
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p);

	/// <summary>
	///   ��ʼ��,����DLL��ִ��
	/// </summary>
	/// procedure CheckInitalize; stdcall;
	void __stdcall CheckInitalize();

	/// <summary>
	///   ж��DLL֮ǰִ��
	/// </summary>
	/// procedure CheckFinalize; stdcall;
	void __stdcall CheckFinalize();

	/// <summary>
	///   ��������bean����ص�����,�Ḳ��֮ǰ��Bean����
	///    pvConfig��Json��ʽ
	///      beanID(mapKey)
	///      {
	///          id:xxxx,
	///          .....
	///      }
	/// </summary>
	/// function ConfigBeans(pvConfig:PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBeans(PMyBeanChar config);

	/// <summary>
	///   ����bean�������Ϣ
	///     pvConfig��Json��ʽ�Ĳ���
	///     �Ḳ��֮ǰ��bean����
	///      {
	///          id:xxxx,
	///          .....
	///      }
	/// </summary>
	/// function ConfigBean(pvBeanID, pvConfig: PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBean(PMyBeanChar beanId, PMyBeanChar config);


	/// <summary>
	///   ����bean����
	///     pluginID,�ڲ��Ĳ��ID
	/// </summary>
	/// function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBeanPluginID(PMyBeanChar beanId, PMyBeanChar pluginId);

	/// <summary>
	///   ����bean����
	///     singleton,��ʵ��,
	///     ���õ�ʵ��ʱ����ע��Ҫô�����нӿڹ����������ڣ�Ҫôʵ��IFreeObject�ӿ�
	///     ��Ҫ�ֶ��ͷ��ͷŶ���.
	/// </summary>
	/// function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean) : Integer; stdcall;
	int __stdcall ConfigBeanSingleton(PMyBeanChar beanId, bool pvSingleton);
};


