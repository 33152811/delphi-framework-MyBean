unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess, uIFileAccess,
  uFileOperaObject;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject
     , IRemoteFileAccess
     , IQueryProgressInfo
     , IFileAccess
     , IFileAccessEx
     , IFileAccess02
     , IRemoteConnector)
  private
    FFileOperaObject: TFileOperaObject;
  protected

    /// <summary>
    ///   �ϴ��ļ�
    /// </summary>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    procedure UploadFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    /// <summary>
    ///   ɾ���ļ�
    /// </summary>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    procedure DeleteFile(pvRFileName, pvType: PAnsiChar);
    /// <summary>
    ///   �����ļ�
    /// </summary>
    /// <returns>
    ///   ���سɹ�����True
    /// </returns>
    /// <param name="pvRFileName"> Զ���ļ��� </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    function DownFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar): Boolean;


    /// <summary>
    ///   ��ȡԶ���ļ���С
    /// </summary>
    function FileSize(pvRFileName, pvType: PAnsiChar): Int64;
  public
    /// <summary>
    ///  ��ѯ���
    /// </summary>
    function QueryMax: Int64; stdcall;

    /// <summary>
    ///  ��ѯ��ǰ����
    /// </summary>
    function QueryPosition: Int64; stdcall;

  public

    /// <summary>
    ///   �����ļ�
    /// </summary>
    /// <param name="pvRFileName"> �ļ�ID </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    procedure saveFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);


    /// <summary>
    ///   ��ȡ�ļ�
    /// </summary>
    /// <returns>
    ///   ��ȡ�ɹ���
    /// </returns>
    /// <param name="pvRFileName"> �ļ�ID </param>
    /// <param name="pvLocalFileName"> ��ȡ�����󱣴��ڱ����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    /// <param name="pvRaiseIfFalse"> �Ƿ�Raise���� </param>
    function getFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar;
        pvRaiseIfFalse: Boolean = true): Boolean;

    /// <summary>
    ///   COPY�ļ�
    /// </summary>
    /// <param name="pvRSourceFileName"> Զ��Դ�ļ� </param>
    /// <param name="pvLocalFileName"> Զ��Ŀ���ļ� </param>
    /// <param name="pvType"> ���� </param>
    procedure copyAFile(pvRSourceFileName, pvRDestFileName, pvType: PAnsiChar); 
  public
    constructor Create;
    procedure AfterConstruction;override;
    procedure SetHost(pvHost: PAnsiChar); stdcall;
    procedure SetPort(pvPort:Integer); stdcall;
    procedure Open; stdcall;
    procedure Close;stdcall;
    destructor Destroy; override;
  end;

implementation

procedure TDIOCPFileAccessImpl.AfterConstruction;
begin
  inherited AfterConstruction;
  FFileOperaObject := TFileOperaObject.Create;
end;

procedure TDIOCPFileAccessImpl.Close;
begin
  FFileOperaObject.BreakWork := True;
  FFileOperaObject.close;  
end;

procedure TDIOCPFileAccessImpl.copyAFile(pvRSourceFileName, pvRDestFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.copyAFile(pvRSourceFileName, pvRDestFileName, pvType);
end;

constructor TDIOCPFileAccessImpl.Create;
begin
  inherited Create;

end;

procedure TDIOCPFileAccessImpl.DeleteFile(pvRFileName, pvType: PAnsiChar);
begin
  FFileOperaObject.deleteFile(pvRFileName, pvType);
end;

destructor TDIOCPFileAccessImpl.Destroy;
begin
  if FFileOperaObject <> nil then FFileOperaObject.Free;
  inherited Destroy;
end;

function TDIOCPFileAccessImpl.DownFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar): Boolean;
begin
  FFileOperaObject.downFile(pvRFileName, pvLocalFileName, pvType);
  Result := true;
end;

function TDIOCPFileAccessImpl.FileSize(pvRFileName, pvType: PAnsiChar): Int64;
begin
  FFileOperaObject.readFileINfo(pvRFileName, pvType, False);
  Result := FFileOperaObject.FileSize;
end;

function TDIOCPFileAccessImpl.getFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar; pvRaiseIfFalse: Boolean): Boolean;
begin
  FFileOperaObject.downFile(pvRFileName, pvLocalFileName, pvType);
  Result := true;
end;

procedure TDIOCPFileAccessImpl.Open;
begin
  FFileOperaObject.close;
  FFileOperaObject.Open;
  FFileOperaObject.BreakWork := False;
end;

function TDIOCPFileAccessImpl.QueryMax: Int64;
begin
  Result := FFileOperaObject.Max;
end;

function TDIOCPFileAccessImpl.QueryPosition: Int64;
begin
  Result := FFileOperaObject.Position;
end;

procedure TDIOCPFileAccessImpl.saveFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.uploadFile(pvRFileName, pvLocalFileName, pvType);
end;

procedure TDIOCPFileAccessImpl.SetHost(pvHost: PAnsiChar);
begin
  FFileOperaObject.setHost(pvHost);
end;

procedure TDIOCPFileAccessImpl.SetPort(pvPort:Integer);
begin
  FFileOperaObject.setPort(pvPort);
end;

procedure TDIOCPFileAccessImpl.UploadFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.uploadFile(pvRFileName, pvLocalFileName, pvType);

end;

end.
