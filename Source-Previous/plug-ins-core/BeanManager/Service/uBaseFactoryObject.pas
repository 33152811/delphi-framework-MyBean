unit uBaseFactoryObject;

interface

uses
  uIBeanFactory, superobject;

type
  TBaseFactoryObject = class(TObject)
  protected
    /// <summary>
    ///   bean������,�ļ��ж�ȡ����һ��list��������
    /// </summary>
    FConfig: ISuperObject;
  protected
    FbeanFactory: IBeanFactory;
    Fnamespace: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure cleanup;virtual;

    procedure checkFinalize;virtual;
    procedure checkInitialize;virtual;
    
    /// <summary>
    ///   beanID��������Ϣ
    /// </summary>
    procedure addBeanConfig(pvBeanConfig: ISuperObject);

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
  FConfig.O['list'] := SO('[]');
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

procedure TBaseFactoryObject.checkFinalize;
begin
  if FbeanFactory <> nil then
  begin
    FbeanFactory.checkFinalize;
  end;
end;

procedure TBaseFactoryObject.checkInitialize;
begin

end;

procedure TBaseFactoryObject.cleanup;
begin
  FbeanFactory := nil;
end;

procedure TBaseFactoryObject.addBeanConfig(pvBeanConfig: ISuperObject);
begin
  FConfig.A['list'].Add(pvBeanConfig);
end;

end.
