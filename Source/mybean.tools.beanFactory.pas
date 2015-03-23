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
    ///   ��ȡApplicationContext�ӿ�
    /// </summary>
    class function ApplicationContext: IApplicationContext;

    /// <summary>
    ///   ��ȡ ApplicationKeyMap�ӿ�
    /// </summary>
    class function ApplicationKeyMap: IKeyMap;


    /// <summary>
    ///   ���c
    /// </summary>
    class procedure CheckRaiseErrorINfo(const pvIntf: IInterface);

    /// <summary>
    ///   ����beanID��ȡ��Ӧ�Ĳ���ӿ�,
    ///      ���beanID��Ӧ������Ϊ��ʵ��ģʽ����Ӧ�Ķ���ֻ�ᴴ��һ��
    /// </summary>
    class function GetBean(pvBeanID: string; pvRaiseIfNil: Boolean = true):
        IInterface;

    /// <summary>
    ///   �ͷŲ��
    /// </summary>
    class procedure FreeBeanInterface(const pvInterface:IInterface);

    /// <summary>
    ///   ���ȫ�ֵĶ���
    /// </summary>
    class procedure SetObject(const pvID: AnsiString; const pvObject: IInterface);

    /// <summary>
    ///   ���õõ�ȫ�ֵĽӿڶ���
    /// </summary>
    class function GetObject(const pvID:AnsiString): IInterface;


    /// <summary>
    ///   �жϲ���Ƿ����
    /// </summary>
    class function ExistsObject(pvID:String): Boolean;

    /// <summary>
    ///   �Ƴ�ȫ�ֵĽӿڶ���
    /// </summary>
    class procedure RemoveObject(pvID:AnsiString);
  end;

implementation



class function TMyBeanFactoryTools.ApplicationContext: IApplicationContext;
begin
  if @GetApplicationContextFunc <> nil then
  begin
    Result := GetApplicationContextFunc();
  end else
  begin
    Result := mybean.core.intf.appPluginContext;
  end;
  if Result = nil then
  begin
    raise Exception.Create('�޷���ȡappPluginContext�ӿ�,��ȷ������Ƿ��ʼ��!');
  end;
end;

class function TMyBeanFactoryTools.ApplicationKeyMap: IKeyMap;
begin
  if @GetApplicationKeyMapFunc <> nil then
  begin
    Result := GetApplicationKeyMapFunc();

  end else
  begin
    Result := mybean.core.intf.ApplicationKeyMap;
  end;
  if Result = nil then
  begin
    raise Exception.Create('�޷���ȡApplicationKeyMap�ӿ�,��ȷ������Ƿ��ʼ��!');
  end;
end;

class procedure TMyBeanFactoryTools.CheckRaiseErrorINfo(const pvIntf:
    IInterface);
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

class function TMyBeanFactoryTools.ExistsObject(pvID:String): Boolean;
begin
  Result := ApplicationKeyMap.ExistsObject(PAnsiChar(AnsiString(pvID)));
end;

class procedure TMyBeanFactoryTools.FreeBeanInterface(const
    pvInterface:IInterface);
var
  lvFree:IFreeObject;
begin
  if pvInterface.QueryInterface(IFreeObject, lvFree) = S_OK then
  begin
    lvFree.FreeObject;
    lvFree := nil;
  end;
end;

class function TMyBeanFactoryTools.GetBean(pvBeanID: string; pvRaiseIfNil:
    Boolean = true): IInterface;
var
  lvFactory:IBeanFactory;
begin
  lvFactory := ApplicationContext.getBeanFactory(PAnsiChar(AnsiString(pvBeanID))) as IBeanFactory;
  if lvFactory = nil then
  begin
    if pvRaiseIfNil then
      raise Exception.CreateFmt('�Ҳ������[%s]��Ӧ�Ĺ���', [pvBeanID]);
  end else
  begin
    result := lvFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
    if (Result = nil) and (pvRaiseIfNil) then
    begin
      CheckRaiseErrorINfo(lvFactory);
    end;
  end;
end;

class function TMyBeanFactoryTools.GetObject(const pvID:AnsiString): IInterface;
begin
  Result := ApplicationKeyMap.GetObject(PAnsiChar(pvID));
end;

class procedure TMyBeanFactoryTools.RemoveObject(pvID:AnsiString);
begin
  if ApplicationKeyMap <> nil then
    ApplicationKeyMap.RemoveObject(PAnsiChar(pvID));
end;


class procedure TMyBeanFactoryTools.SetObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  ApplicationKeyMap.SetObject(PAnsiChar(pvID), pvObject);
end;

end.


