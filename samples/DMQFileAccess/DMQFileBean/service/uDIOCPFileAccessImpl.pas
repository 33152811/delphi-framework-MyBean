unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess,
  uFileOperaObject, uIFileAccess;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject,
    IRemoteFileAccess, IRemoteConnector
    , IFileAccess
    , IFileAccess02
    )
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
    ///   �����ļ�
    /// </summary>
    /// <param name="pvRFileName"> �ļ�ID </param>
    /// <param name="pvLocalFileName"> �����ļ��� </param>
    /// <param name="pvType"> ���� </param>
    procedure FileAccess_saveFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    //ɾ���ļ�
    procedure FileAccess_deleteFile(pvRFileName, pvType: PAnsiChar);

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
    function FileAccess_getFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar;
        pvRaiseIfFalse: Boolean = true): Boolean;

    function IFileAccess.GetFile = FileAccess_getFile;
    procedure IFileAccess.saveFile = FileAccess_saveFile;
    procedure IFileAccess.deleteFile = FileAccess_deleteFile;
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
  FFileOperaObject.close;  
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

procedure TDIOCPFileAccessImpl.FileAccess_deleteFile(pvRFileName,
  pvType: PAnsiChar);
begin
  DeleteFile(pvRFileName, pvType);  
end;

function TDIOCPFileAccessImpl.FileAccess_getFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar; pvRaiseIfFalse: Boolean): Boolean;
begin
  Result := DownFile(pvRFileName,pvLocalFileName, pvType);
end;

procedure TDIOCPFileAccessImpl.FileAccess_saveFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin
  UploadFile(pvRFileName, pvLocalFileName, pvType);
end;

function TDIOCPFileAccessImpl.FileSize(pvRFileName, pvType: PAnsiChar): Int64;
begin
  FFileOperaObject.readFileINfo(pvRFileName, pvType, False);
  Result := FFileOperaObject.FileSize;
end;

procedure TDIOCPFileAccessImpl.Open;
begin
  FFileOperaObject.close;
  FFileOperaObject.Open;
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
