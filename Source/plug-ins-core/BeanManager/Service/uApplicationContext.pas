unit uApplicationContext;

interface

uses
  Classes, SysUtils, uLibFactoryObject, uIAppliationContext, Windows,
  uIBeanFactory,
  uIBeanFactoryRegister,
  uFactoryInstanceObject, uBaseFactoryObject,
  uKeyInterface, uKeyMapImpl, uIKeyMap, IniFiles;

type
  TApplicationContext = class(TInterfacedObject
     , IApplicationContext
     , IbeanFactoryRegister
     )
  private
    FINIFile:TIniFile;

    FTraceLoadFile: Boolean;

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

    procedure checkCreateINIFile;

    function checkInitializeFactoryObject(pvFactoryObject:TBaseFactoryObject;
        pvRaiseException:Boolean): Boolean;
  protected
    /// <summary>
    ///   ֱ�Ӵ�DLL�м��ز������û�������ļ��������ִ��
    /// </summary>
    procedure executeLoadLibrary; stdcall;

    /// <summary>
    ///   �����ṩ��Lib�ļ��õ�TLibFactoryObject����������б��в�����������һ������
    /// </summary>
    function checkCreateLibObject(pvFileName:string): TLibFactoryObject;

    /// <summary>
    ///   ����Lib��Cache��ʱĿ¼
    /// </summary>
    procedure checkProcessLib2Cache(pvLib:TLibFactoryObject);
  private
    /// <summary>
    ///   DLL��ʱ����Ŀ¼
    /// </summary>
    FLibCachePath:String;

    /// <summary>
    ///   ʹ�ò������Ŀ¼
    /// </summary>
    FuseCache:Boolean;

    /// <summary>
    ///   Ӧ�ó����Ŀ¼
    /// </summary>
    FRootPath:String;

    /// <summary>
    ///   �ӵ��������ļ������ò��, ���سɹ������Bean��������
    ///      ������������Bean��ӦlibFile�����(TLibFactoryObject)
    /// </summary>
    function executeLoadFromConfigFile(pvFileName: String): Integer;

    /// <summary>
    ///   �Ӷ�������ļ��ж�ȡ���ò��, ���سɹ������Bean��������
    /// </summary>
    function executeLoadFromConfigFiles(pvFiles: TStrings): Integer;

    /// <summary>
    ///   ׼����������ȡ�����ļ�
    /// </summary>
    procedure checkReady;

    /// <summary>
    ///   ����Bean��Lib����(��FBeanMapList��ע���ϵ)
    /// </summary>
    function checkRegisterBean(pvBeanID: string; pvFactoryObject:
        TBaseFactoryObject): Boolean;


    /// <summary>
    ///   �������ļ��м���, ���سɹ������Bean��������
    /// </summary>
    function checkInitializeFromConfigFiles(pvConfigFiles: string): Integer;


    /// <summary>
    ///   ��ʼ����������
    /// </summary>
    procedure checkInitializeFactoryObjects;

    /// <summary>
    ///   ������DLLcopy������Ŀ¼
    /// </summary>
    procedure checkProcessLibsCache;

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
    procedure checkInitialize; stdcall;

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
  FileLogger, superobject, uSOTools, uFileTools;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup, registerFactoryObject, applicationKeyMap;


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



procedure TApplicationContext.checkInitialize;
var
  lvConfigFiles:String;
begin
  if FFactoryObjectList.Count = 0 then
  begin
    checkReady;
    lvConfigFiles := FINIFile.ReadString('main', 'beanConfigFiles', '');
    if lvConfigFiles <> '' then
    begin
      if FTraceLoadFile then
         TFileLogger.instance.logMessage('�������ļ��м���bean����', 'load_trace');
      if checkInitializeFromConfigFiles(lvConfigFiles) > 0 then
      begin
        if FuseCache then
        begin
          if FTraceLoadFile then
            TFileLogger.instance.logMessage('��DLL�ļ�copy������Ŀ¼[' + self.FLibCachePath + ']', 'load_trace');
          //�����copy������Ŀ¼
          checkProcessLibsCache;
        end;

        if FINIFile.ReadBool('main', 'loadOnStartup', True) then
        begin
          //����DLL�ļ��� ��DLL����
          checkInitializeFactoryObjects;
        end;
      end else
      begin
        if FTraceLoadFile then
          TFileLogger.instance.logMessage('û�м����κ������ļ�', 'load_trace');
      end;
    end else
    begin
      if FTraceLoadFile then
        TFileLogger.instance.logMessage('ֱ�Ӽ���DLL�ļ�', 'load_trace');
      executeLoadLibrary;
    end;

  end;
end;

procedure TApplicationContext.checkReady;
var
  lvTempPath:String;
  l:Integer;
begin
  FRootPath := ExtractFilePath(ParamStr(0));

  FuseCache := FINIFile.ReadBool('main', 'plug-ins-cache', true);

  lvTempPath := FINIFile.ReadString('main', 'plug-ins-cache-path', 'plug-ins-cache\');

  FTraceLoadFile := FINIFile.ReadBool('main','traceLoadLib', FTraceLoadFile);

  FLibCachePath := TFileTools.GetAbsolutePath(FRootPath, lvTempPath);
  l := Length(FLibCachePath);
  if l = 0 then
  begin
    FLibCachePath := FRootPath + 'plug-ins-cache\';
  end else
  begin
    FLibCachePath := TFileTools.PathWithBackslash(FLibCachePath);
  end;

  try
    ForceDirectories(FLibCachePath);
  except
    on E:Exception do
    begin
      TFileLogger.instance.logMessage(
                    Format('�����������Ŀ¼[%s]�����쳣', [FLibCachePath]) + e.Message,
                    'pluginLoaderErr');
    end;
  end;
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
         [lvID,lvLibObject.namespace]), 'load_trace');
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
  checkCreateINIFile;
end;

destructor TApplicationContext.Destroy;
begin
  FINIFile.Free;
  checkFinalize;
  FBeanMapList.Free;
  FFactoryObjectList.Free;
  inherited Destroy;
end;

procedure TApplicationContext.checkCreateINIFile;
var
  lvFile:String;
begin
  lvFile := ChangeFileExt(ParamStr(0), '.config.ini');
  if not FileExists(lvFile) then
     lvFile := FRootPath + 'app.config.ini';

  if not FileExists(lvFile) then
  begin
    FTraceLoadFile := true;
  end;

  FINIFile := TIniFile.Create(lvFile);
end;

function TApplicationContext.checkCreateLibObject(pvFileName:string):
    TLibFactoryObject;
var
  lvNameSpace:String;
  i:Integer;
begin
  Result := nil;
  lvNameSpace :=ExtractFileName(pvFileName);
  if Length(lvNameSpace) = 0 then Exit;

  i := FFactoryObjectList.IndexOf(lvNameSpace);
  if i = -1 then
  begin
    Result := TLibFactoryObject.Create;
    Result.LibFileName := pvFileName;
    FFactoryObjectList.AddObject(lvNameSpace, Result);
  end else
  begin
    Result := TLibFactoryObject(FFactoryObjectList.Objects[i]);
  end;

end;

function TApplicationContext.checkInitializeFactoryObject(
    pvFactoryObject:TBaseFactoryObject; pvRaiseException:Boolean): Boolean;
begin
  try
    if pvFactoryObject.beanFactory = nil then
    begin
      if FTraceLoadFile then
      begin
        TFileLogger.instance.logMessage('׼����ʼ������ļ�[' + String(pvFactoryObject.namespace) + ']', 'loadDLL_trace');
      end;
      pvFactoryObject.checkInitialize;
    end;
    Result := true;
  except
    on E:Exception do
    begin
      Result := false;
      TFileLogger.instance.logMessage(
                    Format('���ز���ļ�[%s]�����쳣:', [pvFactoryObject.namespace]) + e.Message,
                    'loadDLL_trace');
      if pvRaiseException then
        raise;
    end;
  end;
end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:String;
begin
  Result := nil;
  lvBeanID := string(AnsiString(pvBeanID));
  j := FBeanMapList.IndexOf(lvBeanID);
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
      if FTraceLoadFile then
        TFileLogger.instance.logMessage('׼����ʼ��bean����:' + lvFactoryObject.namespace, 'load_trace');
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

function TApplicationContext.checkInitializeFromConfigFiles(pvConfigFiles:
    string): Integer;
var
  lvFilesList, lvStrings: TStrings;
  i: Integer;
  lvStr, lvFileName, lvPath:String;
begin
  Result := 0;
  lvStrings := TStringList.Create;
  lvFilesList := TStringList.Create;
  try
    lvFilesList.Text := StringReplace(pvConfigFiles, ',', sLineBreak, [rfReplaceAll]);
    for i := 0 to lvFilesList.Count - 1 do
    begin
      lvStr := lvFilesList[i];

      lvFileName := ExtractFileName(lvStr);
      lvPath := ExtractFilePath(lvStr);
      lvPath := TFileTools.GetAbsolutePath(FRootPath, lvPath);
      lvFileName := lvPath + lvFileName;


      lvStrings.Clear;
      TFileTools.getFileNameList(lvStrings, lvFileName);
      Result := Result + executeLoadFromConfigFiles(lvStrings);
    end;

  finally
    lvStrings.Free;
  end;
end;

function TApplicationContext.executeLoadFromConfigFile(pvFileName: String):
    Integer;
var
  lvConfig, lvPluginList, lvItem:ISuperObject;
  I: Integer;
  lvLibFile, lvID:String;
  lvLibObj:TBaseFactoryObject;
begin
  Result := 0;
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

          Inc(result);
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

function TApplicationContext.executeLoadFromConfigFiles(pvFiles: TStrings):
    Integer;
var
  i:Integer;
  lvFile:String;
begin
  Result := 0;
  for i := 0 to pvFiles.Count - 1 do
  begin
    lvFile := pvFiles[i];
    Result := Result +  executeLoadFromConfigFile(lvFile);
  end;
end;

procedure TApplicationContext.executeLoadLibrary;
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
    TFileTools.getFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.dll');
    for i := 0 to lvStrings.Count - 1 do
    begin
      lvFile := lvStrings[i];
      lvLib := TLibFactoryObject.Create;
      lvIsOK := false;
      try
        lvLib.LibFileName := lvFile;
        checkProcessLib2Cache(lvLib);

        if checkInitializeFactoryObject(lvLib, False) then
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
      if lvLibObject.beanFactory = nil then
      begin
        if FTraceLoadFile then
          TFileLogger.instance.logMessage('��ʼ��bean����_BEGIN:' + lvLibObject.namespace, 'load_trace');
        lvLibObject.checkInitialize;
        if FTraceLoadFile then
          TFileLogger.instance.logMessage('��ʼ��bean����_END:' + lvLibObject.namespace, 'load_trace');
      end;
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
                    'load_trace');
    end;
  end;
end;

class function TApplicationContext.instance: TApplicationContext;
begin
  Result := __instance;
end;

procedure TApplicationContext.checkProcessLib2Cache(pvLib:TLibFactoryObject);
var
  lvCacheFile, lvFileName, lvSourceFile:String;
begin
  if FuseCache then
  begin
    lvSourceFile := pvLib.libFileName;
    lvFileName := ExtractFileName(lvSourceFile);
    lvCacheFile := FLibCachePath + lvFileName;
    if SameText(lvCacheFile, lvSourceFile) then exit;

    pvLib.libFileName := lvCacheFile;

    if FileExists(lvCacheFile) then
    begin
      DeleteFile(PChar(lvCacheFile));
    end;

    CopyFile(PChar(lvSourceFile), PChar(lvCacheFile), False);
  end;
end;

procedure TApplicationContext.checkProcessLibsCache;
var
  i:Integer;
  lvLibObject:TBaseFactoryObject;
begin
  ///ȫ��ִ��һ��Finalize;
  for i := 0 to FFactoryObjectList.Count -1 do
  begin
    lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    if lvLibObject is TLibFactoryObject then
    begin
      checkProcessLib2Cache(TLibFactoryObject(lvLibObject));
    end;
  end;
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
    FFactoryObjectList.AddObject(String(AnsiString(pvNameSapce)), lvObj);
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
