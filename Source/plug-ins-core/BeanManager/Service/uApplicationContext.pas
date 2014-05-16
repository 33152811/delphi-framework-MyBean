unit uApplicationContext;

interface

uses
  Classes, SysUtils, uLibFactoryObject, uIAppliationContext, Windows,
  uIBeanFactory,
  uIBeanFactoryRegister,
  uFactoryInstanceObject, uBaseFactoryObject,
  uKeyInterface, uKeyMapImpl, uIKeyMap;

type
  TApplicationContext = class(TInterfacedObject
     , IApplicationContext
     , IbeanFactoryRegister
     )
  private
    /// <summary>
    ///   ����FactoryObject�б�,LibFile -> FactoryObject
    /// </summary>
    FFactoryObjectList: TStrings;

    /// <summary>
    ///   ����beanID��FactoryObject�Ķ�Ӧ��ϵ
    /// </summary>
    FBeanMapList: TStrings;

    procedure DoRegisterPluginIDS(pvPluginIDS: String; pvFactoryObject:
        TBaseFactoryObject);
    procedure DoRegisterPlugins(pvPlugins: TStrings; pvFactoryObject:
        TBaseFactoryObject);
  protected
    //ֱ�Ӽ���ģ���ļ�
    procedure ExecuteLoadLibrary; stdcall;

    /// <summary>
    ///   �����ṩ��Lib�ļ��õ�TLibFactoryObject����������б��в�����������һ������
    /// </summary>
    function checkCreateLibObject(pvFileName:string): TLibFactoryObject;

  private
    FLibCachePath:String;
    FRootPath:String;

    /// <summary>
    ///   �ӵ��������ļ������ò��
    /// </summary>
    procedure executeLoadFromConfigFile(pvFileName: String);

    /// <summary>
    ///   �Ӷ�������ļ��ж�ȡ���ò��
    /// </summary>
    procedure executeLoadFromConfigFiles(pvFiles: TStrings);

    procedure checkReady;

    /// <summary>
    ///   ����Bean��Lib����(��FBeanMapList��ע���ϵ)
    /// </summary>
    function checkRegisterBean(pvBeanID: string; pvFactoryObject:
        TBaseFactoryObject): Boolean;


    /// <summary>
    ///   �������ļ��м���
    /// </summary>
    procedure checkInitializeFromConfigFiles;


    /// <summary>
    ///   ��ʼ����������
    /// </summary>
    procedure checkInitializeFactoryObjects;

  public
    constructor Create;
    procedure BeforeDestruction; override;

    destructor Destroy; override;

    /// <summary>
    ///   ִ�з���ʼ��
    /// </summary>
    procedure checkFinalize; stdcall;

    /// <summary>
    ///   ִ�г�ʼ��
    /// </summary>
    procedure checkInitialize(pvLoadLib:Boolean); stdcall;

    /// <summary>
    ///   ��ȡ����BeanID��ȡһ������
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   ��ȡbeanID��Ӧ�Ĺ����ӿ�
    /// </summary>
    function getBeanFactory(pvBeanID:PAnsiChar): IInterface; stdcall;

  protected
    /// <summary>
    ///   ֱ��ע��Bean�������
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;

  public


    class function instance: TApplicationContext;

  end;

/// <summary>
///   ��ȡȫ�ֵ�appliationContext
/// </summary>
function appPluginContext: IApplicationContext; stdcall;

/// <summary>
///   Ӧ�ó�������
/// </summary>
procedure appContextCleanup; stdcall;

/// <summary>
///   ע��beanFactory
/// </summary>
function registerFactoryObject(const pvBeanFactory:IBeanFactory; const
    pvNameSapce:PAnsiChar): Integer; stdcall;





implementation

uses
  FileLogger, superobject, uSOTools;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup, registerFactoryObject, applicationKeyMap;

function GetFileNameList(aList: TStrings; const aSearchPath: string): integer;
var
  dirinfo: TSearchRec;
  dir, lCurrentDir: string;
begin
  result := 0;
  lCurrentDir := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(ParamStr(0)));
  try
    dir := ExtractFilePath(ExpandFileName(aSearchPath));
    if (dir <> '') then
      dir := IncludeTrailingPathDelimiter(dir);

    if (SysUtils.FindFirst(aSearchPath, faArchive, dirinfo) = 0) then repeat
        aList.Add(dir + dirinfo.Name);
        Inc(result);
      until (FindNext(dirinfo) <> 0);
    SysUtils.FindClose(dirinfo);
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

function appPluginContext: IApplicationContext;
begin
  Result := TApplicationContext.instance;
end;

procedure appContextCleanup; stdcall;
begin
  //����KeyMap����
  executeKeyMapCleanup;

  if __instanceIntf = nil then exit;
  try
    try
      __instance.checkFinalize;
    except
    end;
    if __instance.RefCount > 1 then
    begin
      TFileLogger.instance.logErrMessage(Format('appPluginContext����[%d]δ�ͷŵ����', [__instance.RefCount-1]));
    end;
    __instanceIntf := nil;
  except
  end;
end;

function registerFactoryObject(const pvBeanFactory:IBeanFactory; const
    pvNameSapce:PAnsiChar): Integer;
begin
  try
    Result := TApplicationContext.instance.registerBeanFactory(pvBeanFactory, pvNameSapce);
  except
    Result := -1;
  end;
end;



procedure TApplicationContext.checkInitialize(pvLoadLib:Boolean);
begin
  if FFactoryObjectList.Count = 0 then
  begin
    //ExecuteLoadLibrary;
    checkReady;
    checkInitializeFromConfigFiles();

    if pvLoadLib then
    begin
      //����DLL�ļ�
      checkInitializeFactoryObjects;
    end;
  end;
end;

procedure TApplicationContext.checkReady;
begin
  FRootPath := ExtractFilePath(ParamStr(0));
  FLibCachePath := FRootPath + 'plug-ins-cache\';
  ForceDirectories(FLibCachePath);

end;

function TApplicationContext.checkRegisterBean(pvBeanID: string;
    pvFactoryObject: TBaseFactoryObject): Boolean;
var
  j:Integer;
  lvID:String;
  lvLibObject:TBaseFactoryObject;
begin
  Result := false;
  lvID := trim(pvBeanID);
  if (lvID <> '') then
  begin
    j := FBeanMapList.IndexOf(lvID);
    if j <> -1 then
    begin
      lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
      TFileLogger.instance.logMessage(Format('��ע����[%s]ʱ�����ظ�,�Ѿ���[%s]������ע��',
         [lvID,lvLibObject.namespace]));
    end else
    begin
      FBeanMapList.AddObject(lvID, pvFactoryObject);
      Result := true;
    end;
  end;
end;

procedure TApplicationContext.BeforeDestruction;
begin
  inherited;  
end;

procedure TApplicationContext.checkFinalize;
var
  lvLibObject:TBaseFactoryObject;
  i:Integer;
begin
  ///�����applicationKeyMap�е�ȫ����Դ
  applicationKeyMap.cleanupObjects;


  ///ȫ��ִ��һ��Finalize;
  for i := 0 to FFactoryObjectList.Count -1 do
  begin
    lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    lvLibObject.checkFinalize;
  end;

  ///ж��DLL
  for i := 0 to FFactoryObjectList.Count -1 do
  begin
    try
      lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
      lvLibObject.cleanup;
      lvLibObject.Free;
    except
    end;
  end;
  FFactoryObjectList.Clear;
  FBeanMapList.Clear;
end;

constructor TApplicationContext.Create;
begin
  inherited Create;
  FFactoryObjectList := TStringList.Create();
  FBeanMapList := TStringList.Create;
end;

destructor TApplicationContext.Destroy;
begin
  checkFinalize;
  FBeanMapList.Free;
  FFactoryObjectList.Free;
  inherited Destroy;
end;

function TApplicationContext.checkCreateLibObject(pvFileName:string):
    TLibFactoryObject;
var
  lvFileName, lvCacheFile:String;
  i:Integer;
begin
  Result := nil;
  lvFileName :=ExtractFileName(pvFileName);
  if Length(lvFileName) = 0 then Exit;

  i := FFactoryObjectList.IndexOf(lvFileName);
  if i = -1 then
  begin
    lvCacheFile := FLibCachePath + lvFileName;
    if FileExists(lvCacheFile) then
      DeleteFile(PChar(lvCacheFile));

    CopyFile(PChar(pvFileName), PChar(lvCacheFile),False);


    Result := TLibFactoryObject.Create;
    Result.LibFileName := lvCacheFile;
    FFactoryObjectList.AddObject(lvFileName, Result);
  end else
  begin
    Result := TLibFactoryObject(FFactoryObjectList.Objects[i]);
  end;

end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  j := FBeanMapList.IndexOf(String(lvBeanID));
  if j <> -1 then
  begin
    lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
    Result := lvLibObject.getBean(lvBeanID);
  end;
end;

procedure TApplicationContext.DoRegisterPluginIDS(pvPluginIDS: String;
    pvFactoryObject: TBaseFactoryObject);
var
  lvStrings:TStrings;
begin
  lvStrings := TStringList.Create;
  try
    lvStrings.Text := pvPluginIDS;
    DoRegisterPlugins(lvStrings, pvFactoryObject);
  finally
    lvStrings.Free;
  end;               
end;

procedure TApplicationContext.DoRegisterPlugins(pvPlugins: TStrings;
    pvFactoryObject: TBaseFactoryObject);
var
  i, j:Integer;
  lvID:String;
  lvLibObject:TBaseFactoryObject;
begin
  for i := 0 to pvPlugins.Count - 1 do
  begin
    lvID := trim(pvPlugins[i]);
    if (lvID <> '') then
    begin
      j := FBeanMapList.IndexOf(lvID);
      if j <> -1 then
      begin
        lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
        TFileLogger.instance.logMessage(Format('��ע����[%s]ʱ�����ظ�,�Ѿ���[%s]������ע��',
           [lvID,lvLibObject.namespace]));
      end else
      begin
        FBeanMapList.AddObject(lvID, pvFactoryObject);
      end;
    end;
  end;
end;

procedure TApplicationContext.checkInitializeFactoryObjects;
var
  i: Integer;
  lvFactoryObject:TBaseFactoryObject;
begin
  for i := 0 to FFactoryObjectList.Count -1  do
  begin
    lvFactoryObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    try
      lvFactoryObject.checkInitialize;
    except
      on E:Exception do
      begin
        TFileLogger.instance.logMessage(
                      Format('���ز���ļ�[%s]�����쳣', [lvFactoryObject.namespace]) + e.Message,
                      'pluginLoaderErr');
      end;
    end;
  end;

end;

procedure TApplicationContext.checkInitializeFromConfigFiles;
var
  lvStrings: TStrings;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, FRootPath + '*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);

    lvStrings.Clear;
    GetFileNameList(lvStrings, FRootPath + 'beanConfig\*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);

    lvStrings.Clear;
    GetFileNameList(lvStrings, FRootPath + 'plug-ins\*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);
  finally
    lvStrings.Free;
  end;
end;

procedure TApplicationContext.executeLoadFromConfigFile(pvFileName: String);
var
  lvConfig, lvPluginList, lvItem:ISuperObject;
  I: Integer;
  lvLibFile, lvID:String;
  lvLibObj:TBaseFactoryObject;
begin
  lvConfig := TSOTools.JsnParseFromFile(pvFileName);
  if lvConfig = nil then Exit;
  if lvConfig.IsType(stArray) then lvPluginList := lvConfig
  else if lvConfig.O['list'] <> nil then lvPluginList := lvConfig.O['list']
  else if lvConfig.O['plugins'] <> nil then lvPluginList := lvConfig.O['plugins'];

  if (lvPluginList = nil) or (not lvPluginList.IsType(stArray)) then
  begin
    TFileLogger.instance.logMessage(Format('�����ļ�[%s]�Ƿ�', [pvFileName]), 'pluginsLoader');
    Exit;
  end;

  for I := 0 to lvPluginList.AsArray.Length - 1 do
  begin
    lvItem := lvPluginList.AsArray.O[i];
    lvLibFile := FRootPath + lvItem.S['lib'];
    if not FileExists(lvLibFile) then
    begin
      TFileLogger.instance.logMessage(Format('δ�ҵ������ļ�[%s]�е�Lib�ļ�[%s]', [pvFileName, lvLibFile]), 'pluginsLoader');
    end else
    begin
      lvLibObj := checkCreateLibObject(lvLibFile);
      if lvLibObj = nil then
      begin
        TFileLogger.instance.logMessage(Format('δ�ҵ�Lib�ļ�[%s]', [lvLibFile]), 'pluginsLoader');
      end else
      begin
        try
          lvID := lvItem.S['id'];

          if lvID = '' then
          begin
            raise Exception.Create('�Ƿ��Ĳ������,û��ָ��beanID:' + sLineBreak + lvItem.AsJSon(true, false));
          end;


          if checkRegisterBean(lvID, lvLibObj) then
          begin
            //�����÷ŵ���Ӧ�Ľڵ������
            lvLibObj.addBeanConfig(lvItem);
          end;
        except
          on E:Exception do
          begin
            TFileLogger.instance.logMessage(
                          Format('���ز���ļ�[%s]�����쳣:', [lvLibObj.namespace]) + e.Message,
                          'pluginLoaderErr');
          end;
        end;
      end;
    end;
  end;
end;

procedure TApplicationContext.executeLoadFromConfigFiles(pvFiles: TStrings);
var
  i:Integer;
  lvFile:String;
begin
  for i := 0 to pvFiles.Count - 1 do
  begin
    lvFile := pvFiles[i];
    executeLoadFromConfigFile(lvFile);
  end;
end;

procedure TApplicationContext.ExecuteLoadLibrary;
var
  lvStrings: TStrings;
  i: Integer;
  lvFile: string;
  lvLib:TLibFactoryObject;
  lvIsOK:Boolean;

  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.dll');
    for i := 0 to lvStrings.Count - 1 do
    begin
      lvFile := lvStrings[i];
      lvLib := TLibFactoryObject.Create;
      lvIsOK := false;
      try
        lvLib.LibFileName := lvFile;
        if lvLib.checkLoadLibrary then
        begin
          try
            ZeroMemory(@lvBeanIDs[1], 4096);
            lvLib.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
            DoRegisterPluginIDS(String(lvBeanIDs), lvLib);
            FFactoryObjectList.AddObject(ExtractFileName(lvFile), lvLib);
            lvIsOK := true;
          except
            on E:Exception do
            begin
              TFileLogger.instance.logMessage(
                            Format('���ز���ļ�[%s]�����쳣', [lvLib.LibFileName]) + e.Message,
                            'pluginLoaderErr');
            end;
          end;
        end;
      finally
        if not lvIsOK then
        begin
          try
            lvLib.DoFreeLibrary;
            lvLib.Free;
          except
          end;
        end;
      end;
    end;
  finally
    lvStrings.Free;
  end;
end;

function TApplicationContext.getBeanFactory(pvBeanID:PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  try
    j := FBeanMapList.IndexOf(String(lvBeanID));
    if j <> -1 then
    begin
      lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
      lvLibObject.checkInitialize;
      Result := lvLibObject.beanFactory;
    end else
    begin
      TFileLogger.instance.logMessage(
                    Format('�Ҳ�����Ӧ��[%s]�������', [lvBeanID]),
                    'pluginLoaderErr');
    end;
  except
    on E:Exception do
    begin
      TFileLogger.instance.logMessage(
                    Format('��ȡ�������[%s]�����쳣', [lvBeanID]) + e.Message,
                    'pluginLoaderErr');
    end;
  end;
end;

class function TApplicationContext.instance: TApplicationContext;
begin
  Result := __instance;
end;

function TApplicationContext.registerBeanFactory(const pvFactory: IBeanFactory;
  const pvNameSapce: PAnsiChar): Integer;
var
  lvObj:TFactoryInstanceObject;
  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  lvObj := TFactoryInstanceObject.Create;
  try
    lvObj.setFactoryObject(pvFactory);
    lvObj.setNameSpace(pvNameSapce);
    ZeroMemory(@lvBeanIDs[1], 4096);
    lvObj.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
    DoRegisterPluginIDS(String(lvBeanIDs), lvObj);
    FFactoryObjectList.AddObject(pvNameSapce, lvObj);
    Result := 0;
  except
    Result := -1;
  end;
end;

initialization
  __instance := TApplicationContext.Create;
  __instanceIntf := __instance;


finalization
  appContextCleanup;


end.
