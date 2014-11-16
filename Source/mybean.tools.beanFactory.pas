(*
 *	 Unit owner: D10.�����
 *	   blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.0(2014-08-29 13:00)
 *     �޸ļ��ط�ʽ(beanMananger.dll-����)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)

unit mybean.tools.beanFactory;

interface

uses
  mybean.core.intf, SysUtils;

type
  TMyBeanFactoryTools = class(TObject)
  public
    /// <summary>
    ///   ��ȡapplicationContext�ӿ�
    /// </summary>
    class function applicationContext: IApplicationContext;

    
    class procedure checkRaiseErrorINfo(const pvIntf: IInterface);

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
    ///   �жϲ���Ƿ����
    /// </summary>
    class function existsObject(pvID:String): Boolean;

    /// <summary>
    ///   �Ƴ�ȫ�ֵĽӿڶ���
    /// </summary>
    class procedure removeObject(pvID:AnsiString);
  end;

implementation



class function TMyBeanFactoryTools.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
end;

class procedure TMyBeanFactoryTools.checkRaiseErrorINfo(const pvIntf: IInterface);
var
  lvErr:IErrorINfo;
  lvErrCode:Integer;
  lvErrDesc:AnsiString;
  j:Integer;
begin
  if pvIntf = nil then exit;
  if pvIntf.QueryInterface(IErrorINfo, lvErr) = S_OK then
  begin
    lvErrCode := lvErr.getErrorCode;
    if lvErrCode <> 0  then
    begin
      j:=lvErr.getErrorDesc(nil, 0);

      if j = 0 then
      begin
        lvErrDesc := 'δ֪�Ĵ�����Ϣ';
      end else
      begin
        if j > 2048 then j := 2048;
        SetLength(lvErrDesc, j + 1);
        j := lvErr.getErrorDesc(PAnsiChar(lvErrDesc), j);
        lvErrDesc[j+1] := #0;
      end;

      if lvErrCode = -1 then
      begin
        raise Exception.Create(string(lvErrDesc));
      end else
      begin
        raise Exception.CreateFmt('������Ϣ:%s' + sLineBreak + '�������:%d', [lvErrDesc, lvErrCode]);
      end;
    end;
  end;


end;

class function TMyBeanFactoryTools.existsObject(pvID: String): Boolean;
begin
  Result := applicationKeyMap.existsObject(PAnsiChar(AnsiString(pvID)));
end;

class procedure TMyBeanFactoryTools.freeBeanInterface(
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

class function TMyBeanFactoryTools.getBean(pvBeanID: string; pvRaiseIfNil: Boolean
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
      checkRaiseErrorINfo(lvFactory);
    end;
  end;
end;

class function TMyBeanFactoryTools.getObject(const pvID: AnsiString): IInterface;
begin
  Result := applicationKeyMap.getObject(PAnsiChar(pvID));
end;

class procedure TMyBeanFactoryTools.removeObject(pvID: AnsiString);
begin
  if applicationKeyMap <> nil then
    applicationKeyMap.removeObject(PAnsiChar(pvID));
end;


class procedure TMyBeanFactoryTools.setObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  applicationKeyMap.setObject(PAnsiChar(pvID), pvObject);
end;

end.

