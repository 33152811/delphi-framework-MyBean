(*
 *	 Unit owner: D10.Mofen
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.0(2014-08-29 13:00)
 *     �޸ļ��ط�ʽ(beanMananger.dll-����)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)
 
unit mybean.console.loader;

interface

uses
  mybean.core.intf, superobject, Windows, SysUtils;

type
  TBaseFactoryObject = class(TObject)
  private
    FTag: Integer;
  protected
    // Delphi�Ŀ��ļ�
    FIsDelphiLib:Boolean;
    /// <summary>
    ///   bean������,�ļ��ж�ȡ����һ��list��������
    /// </summary>
    FConfig: ISuperObject;
  protected
    FBeanFactory: IBeanFactory;
    FNamespace: string;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Cleanup; virtual;

    procedure CheckFinalize; virtual;

    procedure CheckInitialize; virtual;

    procedure StartService;virtual;

    /// <summary>
    ///   ����Ƿ�����Ч�Ĳ�������ļ�
    /// </summary>
    function CheckIsValidLib(pvUnLoadIfSucc: Boolean = false): Boolean; virtual;

    /// <summary>
    ///   beanID��������Ϣ
    /// </summary>
    procedure AddBeanConfig(pvBeanConfig: ISuperObject);

    /// <summary>
    ///   ����beanID��ȡ���
    /// </summary>
    function GetBean(pvBeanID:string): IInterface; virtual;


    function GetBeanForCPlus(pvBeanId:string; out vInstance:IInterface): HRESULT;

    /// <summary>
    ///   DLL��BeanFactory�ӿ�
    /// </summary>
    property BeanFactory: IBeanFactory read FBeanFactory;


    property Namespace: string read FNamespace;

    property Tag: Integer read FTag write FTag;


  end;

  /// <summary>
  ///   �����û��ֶ�ע��ʵ��
  /// </summary>
  TFactoryInstanceObject = class(TBaseFactoryObject)
  public
    procedure SetFactoryObject(const intf:IBeanFactory);
    procedure SetNameSpace(const pvNameSpace: string);
  end;

implementation

uses
  mybean.core.SOTools;

constructor TBaseFactoryObject.Create;
begin
  inherited Create;
  FTag := 0;
  FConfig := SO();
  FConfig.O['list'] := SO('[]');
end;

destructor TBaseFactoryObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

function TBaseFactoryObject.GetBean(pvBeanID:string): IInterface;
var
  lvFactoryCPlus:IBeanFactoryForCPlus;
begin
  if FBeanFactory = nil then
  begin
    CheckInitialize;

    // GetBean��ʱ�����FBeanFactory��û�и�ֵ��
    //  ������ļ��ǰ�����صģ�������Ҫִ��һ��StartService
    StartService;
  end;

  if FBeanFactory <> nil then
  begin
    if FBeanFactory.QueryInterface(IBeanFactoryForCPlus, lvFactoryCPlus) = S_OK then
    begin  // C++ ��ʽ��ȡ
      lvFactoryCPlus.GetBeanForCPlus(PAnsiChar(AnsiString(pvBeanID)), Result);
    end else
    begin
      Result := FBeanFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
    end;
  end;
end;

function TBaseFactoryObject.GetBeanForCPlus(pvBeanId:string; out
    vInstance:IInterface): HRESULT;
var
  lvFactoryCPlus:IBeanFactoryForCPlus;
begin
  if FBeanFactory = nil then
  begin
    CheckInitialize;
  end;

  if FBeanFactory <> nil then
  begin
    if FBeanFactory.QueryInterface(IBeanFactoryForCPlus, lvFactoryCPlus) = S_OK then
    begin  // C++ ��ʽ��ȡ
      Result := lvFactoryCPlus.GetBeanForCPlus(PAnsiChar(AnsiString(pvBeanID)), vInstance);
    end else
    begin
      vInstance := FBeanFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
      Result := S_OK;
    end;
  end else
  begin
    Result := S_FALSE;
  end;
end;

procedure TBaseFactoryObject.StartService;
begin

end;

{ TBaseFactoryObject }

procedure TBaseFactoryObject.CheckFinalize;
begin
  if FBeanFactory <> nil then
  begin
    FBeanFactory.CheckFinalize;
  end;
end;

procedure TBaseFactoryObject.CheckInitialize;
begin

end;

procedure TBaseFactoryObject.Cleanup;
begin
  FBeanFactory := nil;
end;

procedure TBaseFactoryObject.AddBeanConfig(pvBeanConfig: ISuperObject);
begin
  FConfig.A['list'].Add(pvBeanConfig);
end;

function TBaseFactoryObject.CheckIsValidLib(pvUnLoadIfSucc: Boolean = false):
    Boolean;
begin
  Result := False;
end;

procedure TFactoryInstanceObject.SetFactoryObject(const intf:IBeanFactory);
begin
  FbeanFactory := intf;
end;

procedure TFactoryInstanceObject.SetNameSpace(const pvNameSpace: string);
begin
  Fnamespace := pvNameSpace;
end;

end.
