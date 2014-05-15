unit uBaseFactoryObject;

interface

uses
  uIBeanFactory, superobject;

type
  TBaseFactoryObject = class(TObject)
  protected
    /// <summary>
    ///   bean������
    /// </summary>
    FConfig: ISuperObject;
  protected
    FbeanFactory: IBeanFactory;
    Fnamespace: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure cleanup;virtual;
    procedure checkInitialize;virtual;
    
    /// <summary>
    ///   beanID��������Ϣ
    /// </summary>
    procedure configBean(pvBeanID: string; pvBeanConfig: ISuperObject);

    /// <summary>
    ///   ����beanID��ȡ���
    /// </summary>
    function getBean(pvBeanID:string):IInterface; virtual;

    /// <summary>
    ///   DLL��BeanFactory�ӿ�
    /// </summary>
    property beanFactory: IBeanFactory read FBeanFactory;

    property namespace: AnsiString read Fnamespace;
  end;

implementation

uses
  uSOTools;

constructor TBaseFactoryObject.Create;
begin
  inherited Create;
  FConfig := SO();
end;

destructor TBaseFactoryObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

function TBaseFactoryObject.getBean(pvBeanID: string): IInterface;
begin
  if beanFactory = nil then
  begin
    checkInitialize;
  end;

  if beanFactory <> nil then
  begin
    Result := beanFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
  end;
end;

{ TBaseFactoryObject }

procedure TBaseFactoryObject.checkInitialize;
begin
  
end;

procedure TBaseFactoryObject.cleanup;
begin
  FbeanFactory := nil;
end;

procedure TBaseFactoryObject.configBean(pvBeanID: string; pvBeanConfig:
    ISuperObject);
var
  lvMapKey:String;
begin
  lvMapKey := TSOTools.makeMapKey(pvBeanID);
  FConfig.O[lvMapKey] := pvBeanConfig;
end;

end.
