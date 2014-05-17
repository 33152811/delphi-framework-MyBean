unit mBeanFrameVars;

interface

uses
  uAppPluginContext, uIAppliationContext, SysUtils, uIBeanFactory, uIFreeObject;

type
  TmBeanFrameVars = class(TObject)
  public
    /// <summary>
    ///   ��ȡapplicationContext�ӿ�
    /// </summary>
    class function applicationContext: IApplicationContext;

    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ���ӿ�,
    ///      ���beanID��Ӧ������Ϊ��ʵ��ģʽ����Ӧ�Ķ���ֻ�ᴴ��һ��
    /// </summary>
    class function getBean(pvBeanID: string; pvRaiseIfNil: Boolean = true): IInterface;

    /// <summary>
    ///   �ͷŲ��
    /// </summary>
    class procedure freeBeanInterface(const pvInterface:IInterface);

    /// <summary>
    ///   ���ȫ�ֵĶ���
    /// </summary>
    class procedure setObject(const pvID: AnsiString; const pvObject: IInterface);

    /// <summary>
    ///   ���õõ�ȫ�ֵĽӿڶ���
    /// </summary>
    class function getObject(const pvID:AnsiString):IInterface;

    /// <summary>
    ///   �Ƴ�ȫ�ֵĽӿڶ���
    /// </summary>
    class procedure removeObject(pvID:AnsiString);
  end;

implementation

uses
  uErrorINfoTools;


class function TmBeanFrameVars.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
end;

class procedure TmBeanFrameVars.freeBeanInterface(
  const pvInterface: IInterface);
var
  lvFree:IFreeObject;
begin
  if pvInterface.QueryInterface(IFreeObject, lvFree) = S_OK then
  begin
    lvFree.FreeObject;
    lvFree := nil;
  end;
end;

class function TmBeanFrameVars.getBean(pvBeanID: string; pvRaiseIfNil: Boolean
    = true): IInterface;
var
  lvFactory:IBeanFactory;
begin
  lvFactory := applicationContext.getBeanFactory(PAnsiChar(AnsiString(pvBeanID))) as IBeanFactory;
  if lvFactory = nil then
  begin
    if pvRaiseIfNil then
      raise Exception.CreateFmt('�Ҳ������[%s]��Ӧ�Ĺ���', [pvBeanID]);
  end else
  begin
    result := lvFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
    if (Result = nil) and (pvRaiseIfNil) then
    begin
      TErrorINfoTools.checkRaiseErrorINfo(lvFactory);
    end;
  end;
end;

class function TmBeanFrameVars.getObject(const pvID: AnsiString): IInterface;
begin
  Result := applicationKeyMap.getObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.removeObject(pvID: AnsiString);
begin
  applicationKeyMap.removeObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.setObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  applicationKeyMap.setObject(PAnsiChar(pvID), pvObject);
end;

end.
