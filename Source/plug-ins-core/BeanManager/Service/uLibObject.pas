unit uLibObject;

interface

uses
  Windows, SysUtils, Classes, uIBeanFactory, superobject, uSOTools;

type
  /// <summary>
  ///   DLL�ļ�����
  /// </summary>
  TLibObject = class(TObject)
  private
    FLibHandle:THandle;
    FlibFileName: String;

    /// <summary>
    ///   bean������
    /// </summary>
    FConfig: ISuperObject;

  private
    FBeanFactory: IBeanFactory;

    procedure doCreatePluginFactory;

    procedure doInitialize;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    ///   beanID��������Ϣ
    /// </summary>
    procedure configBean(pvBeanID: string; pvBeanConfig: ISuperObject);

    /// <summary>
    ///   �ͷ�Dll���
    /// </summary>
    procedure doFreeLibrary;

    /// <summary>
    ///   ����dll�ļ�
    /// </summary>
    function checkLoadLibrary: Boolean;

    /// <summary>
    ///   DLL�ļ�
    /// </summary>
    property libFileName: String read FlibFileName write FlibFileName;

    /// <summary>
    ///   DLL��BeanFactory�ӿ�
    /// </summary>
    property beanFactory: IBeanFactory read FBeanFactory;
  end;

implementation

constructor TLibObject.Create;
begin
  inherited Create;
  FConfig := SO();
end;

destructor TLibObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

procedure TLibObject.doCreatePluginFactory;
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

procedure TLibObject.doFreeLibrary;
begin
  FBeanFactory := nil;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TLibObject.doInitialize;
begin
  doCreatePluginFactory;
end;

procedure TLibObject.configBean(pvBeanID: string; pvBeanConfig: ISuperObject);
var
  lvMapKey:String;
begin
  lvMapKey := TSOTools.makeMapKey(pvBeanID);
  FConfig.O[lvMapKey] := pvBeanConfig;
end;

function TLibObject.checkLoadLibrary: Boolean;
begin
  if FLibHandle <> 0 then
  begin
    Result := true;
    Exit;
  end;
  if not FileExists(FlibFileName) then
    raise Exception.Create('�ļ�[' + FlibFileName + ']δ�ҵ�!');
  FLibHandle := LoadLibrary(PChar(FlibFileName));
  Result := FLibHandle <> 0;
  if Result then doInitialize;
end;

end.
