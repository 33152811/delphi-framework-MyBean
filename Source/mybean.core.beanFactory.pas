unit mybean.core.beanFactory;

interface

uses
  Classes, SysUtils, SyncObjs, Windows,
{$if CompilerVersion < 23}
  Forms,
{$else}
  Vcl.Forms,
{$ifend}
  mybean.core.intf,
  mybean.core.utils,
  mybean.core.objects,
  superobject;

type
  TPluginInfo = class(TObject)
  private
    FInstance: IInterface;
    FID: string;
    FIsMainForm: Boolean;
    FPluginClass: TClass;
    FSingleton: Boolean;
    procedure checkFreeInstance;
  public
    destructor Destroy; override;
    property ID: string read FID write FID;
    property IsMainForm: Boolean read FIsMainForm write FIsMainForm;
    property PluginClass: TClass read FPluginClass write FPluginClass;
    property Singleton: Boolean read FSingleton write FSingleton;
  end;

  TBeanInfo = class(TObject)
  private
    FbeanID: string;
    FInstance: IInterface;
    procedure checkFreeInstance;
  public
    destructor Destroy; override;
    property beanID: string read FbeanID write FbeanID;

    /// <summary>
    ///   ��ʵ��ʱ ����Ķ���
    /// </summary>
    property Instance: IInterface read FInstance write FInstance;


  end;

  TOnInitializeProc = procedure;stdcall;

  TPluginInfoProc = procedure(pvObject: TPluginInfo); stdcall;

  TOnCreateInstanceProc = function(pvObject: TPluginInfo):TObject; stdcall;
  TOnCreateInstanceProcEX = function(pvObject: TPluginInfo; var vBreak: Boolean):
      TObject; stdcall;


  TBeanFactory = class(TInterfacedObject,
     IBeanFactory,
     IErrorInfo)
  private
    FVclOwners:TComponent;

    FBeforeGetBean: TPluginInfoProc;


    /// <summary>
    ///   bean������
    /// </summary>
    FConfig:ISuperObject;
    FCS: TCriticalSection;
    FInitializeProcInvoked:Boolean;
    FLastErr:String;
    FLastErrCode:Integer;
    FOnCreateInstanceProc: TOnCreateInstanceProc;
    FOnCreateInstanceProcEX: TOnCreateInstanceProcEX;
    FOnInitializeProc: TOnInitializeProc;
    FPlugins: TStrings;
    FBeanList:TStrings;
    function createInstance(pvObject: TPluginInfo): IInterface;
    procedure lock;
    procedure unLock;

    /// <summary>
    ///   ����beanID��ȡ����,���û�з���nilֵ
    /// </summary>
    function findBeanConfig(pvBeanID:PAnsiChar):ISuperObject;

    /// <summary>
    ///   ����beanID��ȡ���ID
    /// </summary>
    function getPluginID(pvBeanID:PAnsiChar):String;



    /// <summary>
    ///   �ڴ�����ʱ������������
    /// </summary>
    function checkBeanConfigSetter(const pvInterface: IInterface; const pvBeanID:
        PAnsiChar): Boolean;

    ///
    function checkGetBeanAccordingBeanConfig(pvBeanID: PAnsiChar; pvPluginInfo:
        TPluginInfo): IInterface;

  protected
    procedure resetErrorINfo;
    /// <summary>
    ///   ��ȡ������룬û�д��󷵻� 0
    /// </summary>
    function getErrorCode: Integer; stdcall;

    /// <summary>
    ///   ��ȡ������Ϣ���ݣ����ض�ȡ���Ĵ�����Ϣ���ȣ�
    ///     ��������pvErrorDescΪnilָ�룬���ش�����Ϣ�ĳ���
    /// </summary>
    function getErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer;  stdcall;
  protected
    procedure clear;
  public
    /// <summary>TBeanFactory.RegisterBean
    /// </summary>
    /// <returns>
    /// 
    /// </returns>
    /// <param name="pvPluginID"> ID </param>
    /// <param name="pvClass"> �� </param>
    /// <param name="pvSingleton"> �Ƿ�ʵ��  </param>
    function RegisterBean(pvPluginID: String; pvClass: TClass; pvSingleton: Boolean
        = false): TPluginInfo;
    procedure RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
     
    constructor Create; virtual;

    destructor Destroy; override;
  protected
    function getBeanMapKey(pvBeanID:PAnsiChar): String;

    function checkGetBeanConfig(pvBeanID:PAnsiChar): ISuperObject;

    /// ��ȡ���еĲ��ID
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// ����һ�����
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;

  public
    /// <summary>
    ///   ��ʼ��,����DLL��ִ��
    /// </summary>
    procedure checkInitalize;stdcall;

    /// <summary>
    ///   ж��DLL֮ǰִ��
    /// </summary>
    procedure checkFinalize;stdcall;

    /// <summary>
    ///   ��������bean����ص�����,�Ḳ��֮ǰ��Bean����
    ///    pvConfig��Json��ʽ
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBeans(pvConfig:PAnsiChar):Integer; stdcall;

    /// <summary>
    ///   ����bean�������Ϣ
    ///     pvConfig��Json��ʽ�Ĳ���
    ///     �Ḳ��֮ǰ��bean����
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   ����bean����
    ///     pluginID,�ڲ��Ĳ��ID
    /// </summary>
    function configBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall;


    /// <summary>
    ///   ����bean����
    ///     singleton,��ʵ��
    /// </summary>
    function configBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean): Integer; stdcall;

  public

    property BeforeGetBean: TPluginInfoProc read FBeforeGetBean write
        FBeforeGetBean;
    property VclOwners: TComponent read FVclOwners;
    property OnInitializeProc: TOnInitializeProc read FOnInitializeProc write
        FOnInitializeProc;

    property OnCreateInstanceProc: TOnCreateInstanceProc read FOnCreateInstanceProc
        write FOnCreateInstanceProc;

    property OnCreateInstanceProcEX: TOnCreateInstanceProcEX read
        FOnCreateInstanceProcEX write FOnCreateInstanceProcEX;

  end;

function getBeanFactory: IBeanFactory; stdcall;
procedure initializeBeanFactory(appContext: IApplicationContext; appKeyMap: IKeyMap); stdcall;


function beanFactory: TBeanFactory;

implementation

uses
  uSOTools;

var
  __instanceObject:TBeanFactory;
  __Instance:IBeanFactory;

exports
  getBeanFactory, initializeBeanFactory;

function getBeanFactory: IBeanFactory; stdcall;
begin
  Result := __Instance;
end;

function beanFactory: TBeanFactory;
begin
  Result := __instanceObject;
end;

procedure initializeBeanFactory(appContext: IApplicationContext; appKeyMap:
    IKeyMap);
begin
  mybean.core.intf.appPluginContext := appContext;
  mybean.core.intf.applicationKeyMap := appKeyMap;
end;



procedure TBeanFactory.checkFinalize;
begin
  FVclOwners.DestroyComponents;
  clear;
end;

function TBeanFactory.checkGetBeanAccordingBeanConfig(pvBeanID: PAnsiChar;
    pvPluginInfo: TPluginInfo): IInterface;
var
  i:Integer;
  lvBeanINfo:TBeanInfo;
  lvConfig:ISuperObject;
  lvIsSingleton:Boolean;
begin
  lvIsSingleton := False;
  lvConfig := findBeanConfig(pvBeanID);
  if lvConfig <> nil then
  begin
    lvIsSingleton := lvConfig.B['singleton'];
  end;
  if lvIsSingleton then
  begin
    lock();
    try
      i := FBeanList.IndexOf(string(AnsiString(pvBeanID)));
      if i = -1 then
      begin
        lvBeanINfo := TBeanInfo.Create;
        try
          lvBeanINfo.FbeanID := string(AnsiString(pvBeanID));
          lvBeanINfo.FInstance := createInstance(pvPluginInfo);
          checkBeanConfigSetter(lvBeanINfo.FInstance, pvBeanID);
        except
          lvBeanINfo.Free;
          raise;
        end;
        Result := lvBeanINfo.FInstance;
        FBeanList.AddObject(string(AnsiString(pvBeanID)), lvBeanINfo);
      end else
      begin
        lvBeanINfo := TBeanInfo(FBeanList.Objects[i]);
        Result := lvBeanINfo.FInstance;
      end;
    finally
      unLock;
    end;
  end else
  begin
    Result := createInstance(pvPluginInfo);
    checkBeanConfigSetter(Result, pvBeanID);
  end;
end;

function TBeanFactory.checkGetBeanConfig(pvBeanID: PAnsiChar): ISuperObject;
var
  lvMapKey:String;
begin
  lvMapKey := getBeanMapKey(pvBeanID);
  Result := FConfig.O[lvMapKey];
  if Result = nil then
  begin
    Result := SO();
    FConfig.O[lvMapKey] := Result;
  end;
end;

procedure TBeanFactory.checkInitalize;
begin
  try
    if Assigned(FOnInitializeProc) and (not FInitializeProcInvoked) then
    begin
      if not FInitializeProcInvoked then
      begin
        FOnInitializeProc();
        FInitializeProcInvoked := true;
      end;
    end;
  except
    on E:Exception do
    begin
      __beanLogger.logMessage('ִ�г�ʼ��ʱ�������쳣' + sLineBreak + e.Message);
    end;
  end;
end;


procedure TBeanFactory.clear;
var
  i: Integer;
begin
  for i := 0 to FBeanList.Count -1 do
  begin
    FBeanList.Objects[i].Free;
  end;
  FBeanList.Clear;

  for i := 0 to FPlugins.Count -1 do
  begin
    FPlugins.Objects[i].Free;
  end;
  FPlugins.Clear;



end;

function TBeanFactory.configBean(pvBeanID, pvConfig: PAnsiChar): Integer;
var
  lvNewConfig, lvConfig:ISuperObject;
begin
  lvNewConfig := SO(String(AnsiString(pvConfig)));
  if (lvNewConfig = nil) or (not lvNewConfig.IsType(stObject)) then
  begin
    Result := -1;
    FLastErr := 'configBeanִ��ʧ��, �Ƿ�������' + sLineBreak + String(AnsiString(pvConfig));
  end else
  begin
    Result := 0;
    lvConfig := checkGetBeanConfig(pvBeanID);
    lvConfig.Merge(lvNewConfig);
  end;
end;

function TBeanFactory.configBeanPluginID(pvBeanID,
  pvPluginID: PAnsiChar): Integer;
var
  lvConfig:ISuperObject;
begin
  lvConfig := checkGetBeanConfig(pvBeanID);
  lvConfig.S['pluginID'] := String(AnsiString(pvPluginID));
  Result := 0;
end;

function TBeanFactory.configBeans(pvConfig: PAnsiChar): Integer;
var
  lvConfig:ISuperObject;
  lvStr:string;
begin
  resetErrorINfo;
  lvStr := string(AnsiString(pvConfig));
  lvConfig := SO(lvStr);
  if lvConfig = nil then
  begin
    Result := -1;
    FLastErr := 'configBeansִ��ʧ��, �Ƿ�������' + sLineBreak + lvStr;
  end else
  begin
    FConfig.Merge(lvConfig);
    Result := 0;
  end;
end;

function TBeanFactory.configBeanSingleton(pvBeanID: PAnsiChar;
  pvSingleton: Boolean): Integer;
var
  lvConfig:ISuperObject;
begin
  lvConfig := checkGetBeanConfig(pvBeanID);
  lvConfig.B['singleton'] := pvSingleton;
  Result := 0;
end;

constructor TBeanFactory.Create;
begin
  inherited Create;
  FVclOwners := TComponent.Create(nil);

  FConfig := SO();
  FPlugins := TStringList.Create;
  FBeanList := TStringList.Create;
  FCS := TCriticalSection.Create();
end;

function TBeanFactory.createInstance(pvObject: TPluginInfo): IInterface;
var
  lvResultObject:TObject;
  lvClass: TClass;
  lvBreak:Boolean;
begin
  lvResultObject := nil;

  ///ʹ���¼������ӿ�
  if Assigned(FOnCreateInstanceProcEX) then
  begin
    lvBreak := false;
    lvResultObject := FOnCreateInstanceProcEX(pvObject, lvBreak);
    if lvResultObject <> nil then
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);
      Exit;
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
    if lvBreak then exit;
  end;


  ///ʹ���¼�2����
  if Assigned(FOnCreateInstanceProc) then
  begin
    lvResultObject := FOnCreateInstanceProc(pvObject);
    if lvResultObject <> nil then
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);
      Exit;
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end;


  ///Ĭ�Ϸ�ʽ����
  lvClass := pvObject.PluginClass;
  if (pvObject.IsMainForm) then
  begin
    Application.CreateForm(TCustomFormClass(lvClass), lvResultObject);
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);      
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end else if lvClass.InheritsFrom(TComponent) then
  begin
    lvResultObject := TComponentClass(lvClass).Create(FVclOwners);
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end else if lvClass.InheritsFrom(TMyBeanInterfacedObject) then
  begin
    lvResultObject := TMyBeanInterfacedObjectClass(lvClass).Create();
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end else
  begin
    lvResultObject := lvClass.Create;
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]δʵ��IInterface�ӿ�,���ܽ��д���bean', [pvObject.FPluginClass.ClassName]);
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end;
end;

destructor TBeanFactory.Destroy;
begin
  FVclOwners.Free;

  clear;
  FreeAndNil(FCS);
  FConfig := nil;
  FPlugins.Free;
  FBeanList.Free;
  inherited Destroy;
end;

function TBeanFactory.checkBeanConfigSetter(const pvInterface: IInterface;
    const pvBeanID: PAnsiChar): Boolean;
var
  lvSetter:IBeanConfigSetter;
  lvConfig:ISuperObject;
  lvConfigStr:string;
begin
  Result := false;
  if pvInterface = nil then exit;
  if pvInterface.QueryInterface(IBeanConfigSetter, lvSetter) = S_OK then
  begin
    lvConfig := findBeanConfig(pvBeanID);
    if lvConfig <> nil then
    begin
      lvConfigStr := lvConfig.AsJSon(True, False);
      lvSetter.setBeanConfig(PAnsiChar(AnsiString(lvConfigStr)));
      Result := true;
      lvConfigStr := '';
    end;
  end;


end;

function TBeanFactory.findBeanConfig(pvBeanID: PAnsiChar): ISuperObject;
var
  lvMapKey:String;
begin
  Result := nil;
  lvMapKey := getBeanMapKey(pvBeanID);
  Result := FConfig.O[lvMapKey];
end;

{ TBeanFactory }

function TBeanFactory.getBean(pvBeanID: PAnsiChar): IInterface;
var
  i:Integer;
  lvPluginINfo:TPluginInfo;
  lvPluginID:String;
begin
  resetErrorINfo;
  lvPluginID := getPluginID(pvBeanID);
  Result := nil;
  try
    i := FPlugins.IndexOf(lvPluginID);
    if i = -1 then
    begin
      FLastErrCode := -1;
      FLastErr := '�Ҳ�����Ӧ�Ĳ��[' + pvBeanID + ']';
      exit;
    end;

    /// ����bean
    if Assigned(FBeforeGetBean) then
    begin
      FBeforeGetBean(lvPluginINfo);
    end;

    lvPluginINfo :=TPluginInfo(FPlugins.Objects[i]);
    if lvPluginINfo.Singleton then
    begin
      lock;
      try
        if lvPluginINfo.FInstance <> nil then
        begin
          Result := lvPluginINfo.FInstance;
          exit;
        end else
        begin
          Result := createInstance(lvPluginINfo);
          checkBeanConfigSetter(Result, pvBeanID);
          lvPluginINfo.FInstance := Result;
        end;
      finally
        unLock;
      end;
    end else
    begin
      Result :=  checkGetBeanAccordingBeanConfig(pvBeanID, lvPluginINfo);
    end;
  except
    on E:Exception do
    begin
      if FLastErrCode = 0 then FLastErrCode := -1;
      FLastErr := E.Message;
      __beanLogger.logMessage(string(FLastErr), 'DEBUG_');
    end;
  end;
end;

function TBeanFactory.getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer;
var
  lvLen:Integer;
  lvStr:AnsiString;
begin
  lvStr := AnsiString(FPlugins.Text);
  lvLen := Length(lvStr);
  if lvLen > pvLength then lvLen := pvLength;
  
  CopyMemory(pvIDs, PAnsiChar(lvStr), lvLen);
  Result := lvLen;
end;

function TBeanFactory.getBeanMapKey(pvBeanID:PAnsiChar): String;
begin
  Result := TSOTools.makeMapKey(String(AnsiString(pvBeanID)));
end;

function TBeanFactory.getErrorCode: Integer;
begin
  Result := FLastErrCode;
end;

function TBeanFactory.getErrorDesc(pvErrorDesc: PAnsiChar;
  pvLength: Integer): Integer;
var
  j:Integer;
  lvStr:AnsiString;
begin
  lvStr := AnsiString(FLastErr);
  j := Length(lvStr);
  if pvErrorDesc <> nil then
  begin
    if j > pvLength then  j := pvLength;
    CopyMemory(pvErrorDesc, PAnsiChar(lvStr), j);
  end;
  Result := j;
  lvStr := '';
end;

function TBeanFactory.getPluginID(pvBeanID: PAnsiChar): String;
var
  lvConfig:ISuperObject;
begin
  Result := '';
  lvConfig := findBeanConfig(pvBeanID);
  if lvConfig <> nil then
  begin
    Result := Trim(lvConfig.S['pluginID']);
    if Result = '' then
    begin
      Result :=Trim(lvConfig.S['id']);
    end;
  end;

  if Result = '' then
  begin
    Result := string(AnsiString(pvBeanID));
  end;

end;

procedure TBeanFactory.lock;
begin
  FCS.Enter;
end;

procedure TBeanFactory.RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
var
  lvObject:TPluginInfo;
begin
  //�Ѿ�ע�᲻�ٽ���ע��
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TPluginInfo.Create;
  lvObject.FID := pvPluginID;
  lvObject.FPluginClass := pvClass;
  lvObject.FIsMainForm := true;
  lvObject.FInstance := nil;
  FPlugins.AddObject(pvPluginID, lvObject);    
end;

procedure TBeanFactory.resetErrorINfo;
begin
  FLastErr := '';
  FLastErrCode := 0;
end;

procedure TBeanFactory.unLock;
begin
  FCS.Leave;
end;

function TBeanFactory.RegisterBean(pvPluginID: String; pvClass: TClass;
    pvSingleton: Boolean = false): TPluginInfo;
var
  lvObject:TPluginInfo;
begin
  Result := nil;
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TPluginInfo.Create;
  lvObject.FID := pvPluginID;
  lvObject.FPluginClass := pvClass;
  lvObject.IsMainForm := false;
  lvObject.FSingleton := pvSingleton;
  lvObject.FInstance := nil;
  FPlugins.AddObject(pvPluginID, lvObject);
  Result := lvObject;
end;

destructor TPluginInfo.Destroy;
begin
  try
    checkFreeInstance;
  except
  end;
  inherited Destroy;
end;

procedure TPluginInfo.checkFreeInstance;
//var
//  lvFree:IFreeObject;
begin
//  if FInstance <> nil then
//  begin
//    if FInstance.QueryInterface(IFreeObject, lvFree)=S_OK then
//    begin
//      FInstance := nil;
//      lvFree.FreeObject;
//      lvFree := nil;
//    end;
//    FInstance := nil;
//  end;

  FInstance := nil;
end;

procedure TBeanInfo.checkFreeInstance;
//var
//  lvFree:IFreeObject;
begin
//  if FInstance <> nil then
//  begin
//    if FInstance.QueryInterface(IFreeObject, lvFree)=S_OK then
//    begin
//      FInstance := nil;
//      lvFree.FreeObject;
//      lvFree := nil;
//    end;
//  end;

  FInstance := nil;


end;

destructor TBeanInfo.Destroy;
begin
  try
    checkFreeInstance;
  except
  end;
  inherited Destroy;
end;

initialization
  __instanceObject := TBeanFactory.Create;
  __Instance := __instanceObject;

finalization
  __instance := nil;

end.
