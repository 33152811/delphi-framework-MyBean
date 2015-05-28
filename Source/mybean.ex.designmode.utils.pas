(*
 * MyBean��չ��Ԫ
 *   �������ģʽ���õ�Ԫ
 *   �õ�Ԫ����Ҫ����MyBeanSubscribeCenter���(�������Ĳ��)
 *
 * 1.0
 *   �����߲��
*)
unit mybean.ex.designmode.utils;

interface

uses
  mybean.ex.designmode.intf, mybean.tools.beanFactory, mybean.core.intf;


/// <summary>
///   ͨ��������ID��ȡһ�������߽ӿ�ʵ��, �����ʵ������������д���������ֱ�ӷ���
///   �̰߳�ȫ�汾
/// </summary>
/// <returns>
///  ���ػ�ȡ�������߽ӿ�ʵ��
/// </returns>
/// <param name="pvPublisherID"> ͬһ��pvPublisherID��ȡ�ķ�����ʵ������ͬ�� </param>
function GetPublisher(const pvPublisherID: string): IPublisher; stdcall;

implementation

function GetPublisher(const pvPublisherID: string): IPublisher;
var
  lvCenter: ISubscribeCenter;
  lvIntf:IInterface;
begin
  Result := nil;
  lvIntf := TMyBeanFactoryTools.GetBean('MyBeanSubscribeCenter');
  if lvIntf.QueryInterface(ISubscribeCenter, lvCenter) = S_OK then
  begin
    lvCenter.GetPublisher(PMyBeanChar(MyBeanString(pvPublisherID)), Result);
  end;                                                                    
end;

end.
