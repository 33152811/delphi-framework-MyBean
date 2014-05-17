unit uLibFactoryObject;

interface

uses
  Windows, SysUtils, Classes, uIBeanFactory, superobject, uSOTools,
  uBaseFactoryObject;

type
  /// <summary>
  ///   DLL�ļ�����
  /// </summary>
  TLibFactoryObject = class(TBaseFactoryObject)
  private
    FLibHandle:THandle;
    FlibFileName: String;

  private

    procedure doCreatePluginFactory;

    procedure doInitialize;
    procedure SetlibFileName(const Value: String);
  public
    procedure checkInitialize; override;

    procedure cleanup;override;

    /// <summary>
    ///   ����beanID��ȡ���
    /// </summary>
    function getBean(pvBeanID:string): IInterface; override;

    /// <summary>
    ///   �ͷ�Dll���
    /// </summary>
    procedure doFreeLibrary;

    /// <summary>
    ///   ����dll�ļ�
    /// </summary>
    function checkLoadLibrary(pvRaiseIfNil: Boolean = true): Boolean;

    /// <summary>
    ///   DLL�ļ�
    /// </summary>
    property libFileName: String read FlibFileName write SetlibFileName;

  end;

implementation

procedure TLibFactoryObject.doCreatePluginFactory;
var
  lvFunc:function:IBeanFactory; stdcall;
begin
  @lvFunc := GetProcAddress(FLibHandle, PChar('getBeanFactory'));
  if (@lvFunc = nil) then
  begin
    raise Exception.CreateFmt('�Ƿ���Pluginģ���ļ�(%s),�Ҳ�����ں���(getBeanFactory)', [self.FlibFileName]);
  end;
  FBeanFactory := lvFunc;
end;

procedure TLibFactoryObject.doFreeLibrary;
begin
  FBeanFactory := nil;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TLibFactoryObject.doInitialize;
begin
  doCreatePluginFactory;
end;

procedure TLibFactoryObject.checkInitialize;
var
  lvConfigStr, lvBeanID:AnsiString;
  lvBeanConfig:ISuperObject;
  i: Integer;
begin
  if FbeanFactory = nil then
  begin
    checkLoadLibrary;

    //�����ô��뵽beanFactory��
    for i := 0 to FConfig.A['list'].Length-1 do
    begin
      lvBeanConfig := FConfig.A['list'].O[i];
      lvBeanID := AnsiString(lvBeanConfig.S['id']);
      lvConfigStr := AnsiString(lvBeanConfig.AsJSon(false, false));

      //���õ���bean
      FbeanFactory.configBean(PAnsiChar(lvBeanID), PAnsiChar(lvConfigStr));
    end;
  end;

  //������ǰ�ͷ�
  lvConfigStr := '';
  lvBeanID:= '';
end;

function TLibFactoryObject.checkLoadLibrary(pvRaiseIfNil: Boolean = true):
    Boolean;
begin
  if FLibHandle <> 0 then
  begin
    Result := true;
    Exit;
  end;
  if not FileExists(FlibFileName) then
  begin
    if pvRaiseIfNil then
    begin
      raise Exception.Create('�ļ�[' + FlibFileName + ']δ�ҵ�!');
    end;
    Result := false;
  end else
  begin
    FLibHandle := LoadLibrary(PChar(FlibFileName));
    Result := FLibHandle <> 0;
    if Result then doInitialize;
  end;
end;

procedure TLibFactoryObject.cleanup;
begin
  doFreeLibrary;
end;

function TLibFactoryObject.getBean(pvBeanID:string): IInterface;
begin
  result := inherited getBean(pvBeanID);
end;

procedure TLibFactoryObject.SetlibFileName(const Value: String);
begin
  FlibFileName := Value;
  Fnamespace := FlibFileName;
end;

end.
