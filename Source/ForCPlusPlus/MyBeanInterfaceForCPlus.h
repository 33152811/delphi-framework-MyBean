#if _MSC_VER > 1000
#pragma once
#endif 

#include <UNKNWN.h>

#define MyBeanChar char 
#define PMyBeanChar char *

typedef IUnknown IInterface;

/// TGetInterfaceFunctionForStdcall = function(out vIntf : IInterface) :HRESULT; stdcall;
typedef HRESULT(__stdcall *TGetInterfaceFunctionForStdcall) (IInterface ** instance);

/// <summary>
///   C++ ���Ե��õĽӿ�, ����̨�ṩ
/// </summary>
interface DECLSPEC_UUID("{9A7238C4-5A47-494B-9058-77500C1622DC}")
IApplicationContextForCPlus: public IInterface{
	/// <summary>
	///   ����beanID��ȡ��Ӧ�Ĳ��
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p) = 0;

	/// <summary>
	///   ��ȡbeanID��Ӧ�Ĺ����ӿ�
	/// </summary>
	/// function GetBeanFactoryForCPlus(pvBeanID:PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanFactoryForCPlus(PMyBeanChar beanId, IInterface **p) = 0;
};


/// <summary>
///   C++ ���Ե��õĽӿ�, ����̨�ṩ
/// </summary>
interface DECLSPEC_UUID("{66828066-38B7-4613-8F9B-627CB76D84F2}")
IStrMapForCPlus: public IInterface{
/// <summary>
///   ����keyֵ��ȡ�ӿ�
/// </summary>
/// function GetValue(pvKey:PAnsiChar; out vIntf : IInterface) : HRESULT; stdcall;
virtual HRESULT __stdcall GetValue(PMyBeanChar beanId, IInterface **p) = 0;


/// <summary>
///  ��ֵ�ӿ�
/// </summary>
/// function SetValue(pvKey:PAnsiChar; pvIntf: IInterface) : HRESULT; stdcall;
virtual HRESULT __stdcall SetValue(PMyBeanChar beanId, IInterface * p) = 0;

/// <summary>
///   �Ƴ��ӿ�
/// </summary>
/// function Remove(pvKey:PAnsiChar) : HRESULT; stdcall;
virtual HRESULT __stdcall Remove(PMyBeanChar beanId) = 0;

/// <summary>
///   �ж��Ƿ���ڽӿ�
/// </summary>
/// function Exists(pvKey:PAnsiChar) : HRESULT; stdcall;
virtual HRESULT __stdcall Exists(PMyBeanChar beanId) = 0;
};


/// <summary>
///   ��������ӿ�,�ɲ������(DLL, BPL)���ļ��ṩ
/// </summary>
interface DECLSPEC_UUID("{480EC845-2FC0-4B45-932A-57711D518E70}")
IBeanFactory: public IInterface{
	/// <summary>
	///   ��ȡ���еĲ��ID
	///     ���ػ�ȡID�ĳ��ȷָ���#10#13
	/// </summary>
	virtual int __stdcall GetBeanList(PMyBeanChar IDs, int len) = 0;

	/// <summary>
	///   ����beanID��ȡ��Ӧ�Ĳ��
	/// </summary>
	///  function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;
	virtual HRESULT __stdcall GetBean(PMyBeanChar beanId) = 0;


	/// <summary>
	///   ��ʼ��,����DLL��ִ��
	/// </summary>
	/// procedure CheckInitalize; stdcall;
	virtual void __stdcall CheckInitalize() = 0;

	/// <summary>
	///   ж��DLL֮ǰִ��
	/// </summary>
	/// procedure CheckFinalize; stdcall;
	virtual void __stdcall CheckFinalize() = 0;

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
	virtual int __stdcall ConfigBeans(PMyBeanChar config) = 0;

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
	virtual int __stdcall ConfigBean(PMyBeanChar beanId, PMyBeanChar config) = 0;


	/// <summary>
	///   ����bean����
	///     pluginID,�ڲ��Ĳ��ID
	/// </summary>
	/// function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar) : Integer; stdcall;
	virtual int __stdcall ConfigBeanPluginID(PMyBeanChar beanId, PMyBeanChar pluginId) = 0;

	/// <summary>
	///   ����bean����
	///     singleton,��ʵ��,
	///     ���õ�ʵ��ʱ����ע��Ҫô�����нӿڹ����������ڣ�Ҫôʵ��IFreeObject�ӿ�
	///     ��Ҫ�ֶ��ͷ��ͷŶ���.
	/// </summary>
	/// function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean) : Integer; stdcall;
	virtual int __stdcall ConfigBeanSingleton(PMyBeanChar beanId, bool pvSingleton) = 0;

	};


	/// <summary>
	///   C++ ����չʵ�ֲ������
	/// </summary>
	interface DECLSPEC_UUID("{D6F1B138-ECEA-44FC-A3E3-0B5169F1077A}")
	IBeanFactory4CPlus: public IInterface{
	/// <summary>
	///   ����beanID��ȡ��Ӧ�Ĳ��
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p) = 0;
	};
	
