unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess,
  uDTcpClientCoderImpl,
  uStreamCoderSocket,
  uZipTools,
  SimpleMsgPack,
  Classes,
  SysUtils,
  DTcpClient, uICoderSocket;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject, IRemoteFileAccess)
  private
    FTcpClient: TDTcpClient;
    FCoderSocket: ICoderSocket;
    FMsgPack:TSimpleMsgPack;
    FSendStream:TMemoryStream;
    FRecvStream:TMemoryStream;
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
    function FileSize(pvRFileName: PAnsiChar): Int64;
  public
    constructor Create;
    procedure setHost(pvHost: string);
    procedure setPort(pvPort:Integer);
    procedure open;
    destructor Destroy; override;
  end;

implementation

constructor TDIOCPFileAccessImpl.Create;
begin
  inherited Create;
  FTcpClient := TDTcpClient.Create(nil);
  FCoderSocket := TDTcpClientCoderImpl.Create(FTcpClient);
  
  FMsgPack := TSimpleMsgPack.Create;
  FRecvStream := TMemoryStream.Create;
  FSendStream := TMemoryStream.Create;
end;

procedure TDIOCPFileAccessImpl.DeleteFile(pvRFileName, pvType: PAnsiChar);
begin
  
end;

destructor TDIOCPFileAccessImpl.Destroy;
begin
  FCoderSocket := nil;
  FTcpClient.Disconnect;
  FTcpClient.Free;
  FMsgPack.Free;
  FRecvStream.Free;
  FSendStream.Free;
  inherited Destroy;
end;

function TDIOCPFileAccessImpl.DownFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar): Boolean;
begin

end;

function TDIOCPFileAccessImpl.FileSize(pvRFileName: PAnsiChar): Int64;
begin

end;

procedure TDIOCPFileAccessImpl.open;
begin
  FTcpClient.Disconnect;
  FTcpClient.Connect;
end;

procedure TDIOCPFileAccessImpl.setHost(pvHost: string);
begin
  FTcpClient.Host := pvHost;
end;

procedure TDIOCPFileAccessImpl.setPort(pvPort: Integer);
begin
  FTcpClient.Port := pvPort;  
end;

procedure TDIOCPFileAccessImpl.UploadFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin

end;

end.
