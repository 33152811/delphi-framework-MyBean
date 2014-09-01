unit uRemoteServerDIOCPImpl;

interface

uses
  uIRemoteServer,
  uRawTcpClientCoderImpl,
  uStreamCoderSocket,
  uZipTools,
  qmsgpack,
  Classes,
  SysUtils,
  RawTcpClient, uICoderSocket;

type
  TRemoteServerDIOCPImpl = class(TInterfacedObject, IRemoteServer, IRemoteServerConnector)
  private
    FTcpClient: TRawTcpClient;
    FCoderSocket: ICoderSocket;
    FMsgPack:TQMsgPack;
    FSendStream:TMemoryStream;
    FRecvStream:TMemoryStream;
  protected
    /// <summary>
    ///   ִ��Զ�̶���
    /// </summary>
    function Execute(pvCmdIndex: Integer; var vData: OleVariant): Boolean; stdcall;
  public
    procedure AfterConstruction; override;
    procedure setHost(pvHost: PAnsiChar);
    procedure setPort(pvPort:Integer);
    procedure open;
    destructor Destroy; override;
  end;

implementation

procedure TRemoteServerDIOCPImpl.AfterConstruction;
begin
  inherited AfterConstruction;
  FTcpClient := TRawTcpClient.Create(nil);
  FCoderSocket := TRawTcpClientCoderImpl.Create(FTcpClient);
  
  FMsgPack := TQMsgPack.Create;
  FRecvStream := TMemoryStream.Create;
  FSendStream := TMemoryStream.Create;
end;

destructor TRemoteServerDIOCPImpl.Destroy;
begin
  FCoderSocket := nil;
  FTcpClient.Disconnect;
  FTcpClient.Free;
  FMsgPack.Free;
  FRecvStream.Free;
  FSendStream.Free;
  inherited Destroy;
end;

{ TRemoteServerDIOCPImpl }

function TRemoteServerDIOCPImpl.Execute(pvCmdIndex: Integer; var vData:
    OleVariant): Boolean;
begin
  if not FTcpClient.Active then FTcpClient.Connect;
  FSendStream.Clear;
  FRecvStream.Clear;
  FMsgPack.Clear;
  FMsgPack.ForcePath('cmd.index').AsInteger := pvCmdIndex;
  FMsgPack.ForcePath('cmd.data').AsVariant := vData;
  FMsgPack.SaveToStream(FSendStream);
  TZipTools.compressStreamEX(FSendStream);

  TStreamCoderSocket.SendObject(FCoderSocket, FSendStream);

  TStreamCoderSocket.RecvObject(FCoderSocket, FRecvStream);

  TZipTools.unCompressStreamEX(FRecvStream);

  FRecvStream.Position := 0;
  
  FMsgPack.LoadFromStream(FRecvStream);

  Result := FMsgPack.ForcePath('__result.result').AsBoolean;

  if not Result then
    if FMsgPack.ForcePath('__result.msg').AsString <> '' then
    begin
      raise Exception.Create(FMsgPack.ForcePath('__result.msg').AsString);
    end;

  vData := FMsgPack.ForcePath('__result.data').AsVariant;
end;

procedure TRemoteServerDIOCPImpl.open;
begin
  FTcpClient.Disconnect;
  FTcpClient.Connect;
end;

procedure TRemoteServerDIOCPImpl.setHost(pvHost: PAnsiChar);
begin
  FTcpClient.Host := AnsiString(pvHost);
end;

procedure TRemoteServerDIOCPImpl.setPort(pvPort: Integer);
begin
  FTcpClient.Port := pvPort;  
end;

end.
