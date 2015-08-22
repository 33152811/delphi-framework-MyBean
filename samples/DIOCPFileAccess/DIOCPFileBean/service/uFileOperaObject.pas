unit uFileOperaObject;

interface

uses
  SysUtils, SimpleMsgPack, Classes, Math, uCRCTools,
  uStreamCoderSocket, DTcpClient, uICoderSocket, uDTcpClientCoderImpl;


type
  TFileOperaObject = class(TObject)
  private
    FBreakWork: Boolean;
    FMax:Int64;
    
    FPosition:Int64;
    
    FFileSize:Int64;
    FFileCheckSum:Cardinal;
    FCoderSocket:ICoderSocket;
    FTcpClient: TDTcpClient;

    FCMDStream: TMemoryStream;
    FCMDObj:TSimpleMsgPack;

    function ChecksumAFile(pvFile:string): Cardinal;
    procedure pressINfo(pvSendObject: TSimpleMsgPack; pvRFile, pvType: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure checkConnect;

    procedure setHost(pvHost: string);
    procedure setPort(pvPort:Integer);

    procedure open;
    procedure close;

    procedure readFileINfo(pvRFile, pvType: string; pvChecksum: Boolean = true);

    function uploadFile(pvRFile:String; pvLocalFile:string; pvType:string): Int64;

    procedure downFile(pvRFile:String; pvLocalFile:string; pvType:string);

    procedure copyAFile(pvRFile, pvRDestFile, pvType: String);

    procedure deleteFile(pvRFile:String; pvType: string);
    class function verifyData(const buf; len:Cardinal): Cardinal;
    class function verifyStream(pvStream:TStream; len:Cardinal): Cardinal;

    property BreakWork: Boolean read FBreakWork write FBreakWork;

    property FileCheckSum: Cardinal read FFileCheckSum;

    property FileSize: Int64 read FFileSize;

    /// <summary>
    ///   ��ѯ�ϴ�/�����ļ������ߴ�
    /// </summary>
    property Max: Int64 read FMax;

    /// <summary>
    ///  ��ѯ�ϴ�/�����ļ��ĵ�ǰ�ߴ�
    /// </summary>
    property Position: Int64 read FPosition;



    
  end;

implementation


const
  SEC_SIZE = 1024 * 50;

procedure TFileOperaObject.checkConnect;
begin
  try
    if not FTcpClient.Active then FTcpClient.Connect;
  except
    on E:Exception do
    begin
      raise Exception.CreateFmt('���ӷ���������[%s:%d]' + sLineBreak + E.Message,
        [FTcpClient.Host, FTcpClient.Port]);
    end;
  end;
end;

procedure TFileOperaObject.close;
begin
  FTcpClient.Disconnect;
end;

procedure TFileOperaObject.copyAFile(pvRFile, pvRDestFile, pvType: String);
var
  lvRecvObj, lvSendObj:TSimpleMsgPack;
begin
  checkConnect;
  lvSendObj := TSimpleMsgPack.Create;
  lvRecvObj := TSimpleMsgPack.Create;
  try
    lvSendObj.Clear();
    lvSendObj.S['cmd.namespace'] := 'fileaccess';
    lvSendObj.I['cmd.index'] := 5;   //copy�ļ�
    lvSendObj.S['fileName'] := pvRFile;
    lvSendObj.S['newFile'] := pvRDestFile;

    lvSendObj.S['catalog'] := pvType;


    TStreamCoderSocket.SendObject(FCoderSocket, lvSendObj);
    TStreamCoderSocket.RecvObject(FCoderSocket, lvRecvObj);
    if not lvRecvObj.B['__result.result'] then
    begin
      raise Exception.Create(lvRecvObj.S['__result.msg']);
    end;
  finally
    lvSendObj.Free;
    lvRecvObj.Free;
  end;    
end;

constructor TFileOperaObject.Create;
begin
  inherited Create;
  FTcpClient := TDTcpClient.Create(nil);
  FCoderSocket := TDTcpClientCoderImpl.Create(FTcpClient);
  FCMDStream := TMemoryStream.Create;
  FCMDObj := TSimpleMsgPack.Create;
end;

procedure TFileOperaObject.deleteFile(pvRFile, pvType: string);
begin
  checkConnect;

  FCMDObj.Clear();
  FCMDObj.S['cmd.namespace'] := 'fileaccess';
  FCMDObj.I['cmd.index'] := 4;   //ɾ���ļ�
  FCMDObj.S['fileName'] := pvRFile;
  FCMDObj.S['catalog'] := pvType;
  FCMDStream.Clear;
  FCMDObj.EncodeToStream(FCMDStream);

  TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

  FCMDStream.Clear;
  TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
  FCMDStream.Position := 0;
  FCMDObj.DecodeFromStream(FCMDStream);

  if not FCMDObj.B['__result.result'] then
  begin
    raise Exception.Create(FCMDObj.S['__result.msg']);
  end;

end;

destructor TFileOperaObject.Destroy;
begin
  FCMDStream.Free;
  FCMDObj.Free;
  FCoderSocket := nil;
  FTcpClient.Free;
  inherited Destroy;
end;

procedure TFileOperaObject.downFile(pvRFile, pvLocalFile, pvType: string);
var
  lvRFileSize:Integer;
var
  lvFileStream:TFileStream;
  lvFileName:String;
  lvChecksum, lvLocalCheckSum:Cardinal;
  lvBytes:TBytes;
begin
  checkConnect;
  
  readFileINfo(pvRFile, pvType, True);

  lvRFileSize := FFileSize;

  if lvRFileSize = 0 then
  begin
    raise Exception.CreateFmt('Զ���ļ�[%s]������!', [pvRFile]);
  end;
  FMax := lvRFileSize;

  lvCheckSum := FFileCheckSum;
  if lvCheckSum = 0 then raise Exception.Create('������ļ�������!');

  lvLocalCheckSum := ChecksumAFile(pvLocalFile);
  if lvCheckSum = lvLocalCheckSum then
  begin
    Exit;
  end;
        
  //���ļ��ֶ�����<ÿ�ι̶���С>
  //ѭ������
  //  {
  //     fileName:'xxxx',  //�ͻ��������ļ�
  //     start:0,          //�ͻ�������ʼλ��

  //     filesize:11111,   //�ļ��ܴ�С
  //     crc:xxxx,         //����˷���
  //     blockSize:4096   //����˷���
  //  }


  lvFileName := pvLocalFile;
  SysUtils.DeleteFile(lvFileName);

  lvFileStream := TFileStream.Create(lvFileName, fmCreate or fmShareDenyWrite);
  try
    while true do
    begin
      FCMDObj.Clear();

      if FBreakWork then Break;
      
      pressINfo(FCMDObj, pvRFile, pvType);


      FCMDObj.I['cmd.index'] := 1;
      FCMDObj.I['start'] := lvFileStream.Position;


      FCMDStream.Clear;
      FCMDObj.EncodeToStream(FCMDStream);

      TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

      FCMDStream.Clear;
      TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
      FCMDStream.Position := 0;
      FCMDObj.DecodeFromStream(FCMDStream);

      if not FCMDObj.B['__result.result'] then
      begin
        raise Exception.Create(FCMDObj.S['__result.msg']);
      end;

//      lvCrc := TCRCTools.crc32Stream(lvRecvObj.Stream);
//      if lvCrc <> lvRecvObj.I['crc'] then
//      begin
//        raise Exception.Create('crcУ��ʧ��!');
//      end;
      lvBytes := FCMDObj.ForcePathObject('data').AsBytes;
      lvFileStream.Write(lvBytes[0], Length(lvBytes));

      FPosition := lvFileStream.Position;
        
      //�ļ��������
      if lvFileStream.Size = FCMDObj.I['fileSize'] then
      begin
        Break;
      end;
    end;
  finally
    lvFileStream.Free;
  end; 
end;

function TFileOperaObject.ChecksumAFile(pvFile:string): Cardinal;
var
  lvFileStream:TFileStream;
begin
  result := 0;
  if FileExists(pvFile) then
  begin
    lvFileStream := TFileStream.Create(pvFile, fmOpenRead);
    try
      result := verifyStream(lvFileStream, 0);
    finally
      lvFileStream.Free;
    end;
  end;  
end;

procedure TFileOperaObject.open;
begin
  FTcpClient.Connect;
  FBreakWork := False;
end;

procedure TFileOperaObject.pressINfo(pvSendObject: TSimpleMsgPack; pvRFile,
    pvType: String);
begin
  pvSendObject.S['cmd.namespace'] := 'fileaccess';
  pvSendObject.S['fileName'] := pvRFile;
  pvSendObject.S['catalog'] := pvType;
end;

procedure TFileOperaObject.readFileINfo(pvRFile, pvType: string; pvChecksum:
    Boolean = true);
begin
  checkConnect;

  FCMDObj.Clear();
  FCMDObj.S['cmd.namespace'] := 'fileaccess';
  FCMDObj.I['cmd.index'] := 3;   //�ļ���Ϣ
  FCMDObj.B['cmd.checksum'] := pvChecksum;   //��ȡchecksumֵ
  FCMDObj.S['fileName'] := pvRFile;
  FCMDObj.S['catalog'] := pvType;

  FCMDStream.Clear;
  FCMDObj.EncodeToStream(FCMDStream);
  TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

  FCMDStream.Clear;
  TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
  FCMDStream.Position := 0;
  FCMDObj.DecodeFromStream(FCMDStream);
  
  if not FCMDObj.B['__result.result'] then
  begin
    raise Exception.Create(FCMDObj.S['__result.msg']);
  end;
  FFileSize := FCMDObj.I['info.size'];
  FFileCheckSum := FCMDObj.I['info.checksum'];

end;

procedure TFileOperaObject.setHost(pvHost: string);
begin
  FTcpClient.Host := pvHost;
end;

procedure TFileOperaObject.setPort(pvPort: Integer);
begin
  FTcpClient.Port := pvPort;
end;

{ TFileOperaObject }


function TFileOperaObject.uploadFile(pvRFile:String; pvLocalFile:string;
    pvType:string): Int64;
var
  lvFileStream:TFileStream;

  lvPosition, lvSize:Int64;
begin
  //���ļ��ֶδ���<ÿ�ι̶���С> 4K
  //ѭ������
  //  {
  //     fileName:'xxxx',
  //     crc:xxxx,
  //     start:0,   //��ʼλ��
  //     eof:true,  //���һ��
  //  }

  checkConnect;
  
  //lvLocalCheckSum := ChecksumAFile(pvLocalFile);

  lvFileStream := TFileStream.Create(pvLocalFile, fmOpenRead);
  try
    FMax := lvFileStream.Size;
    //readFileINfo(pvRFile, pvType);

//    lvCheckSum := FFileCheckSum;
//
//
//    if lvCheckSum = lvLocalCheckSum then
//    begin
////      if FProgConsole <> nil then
////      begin
////        FProgConsole.SetHintText('�봫�ļ�...');
////        FProgConsole.SetPosition(lvFileStream.Size);
////        Sleep(1000);
////      end;
//      Exit;
//    end;

    while true do
    begin                   
      if FBreakWork then Break; 

      FCMDObj.Clear();
      if pvRFile = '' then
      begin
        pressINfo(FCMDObj, ExtractFileName(pvLocalFile), pvType);
      end else
      begin
        pressINfo(FCMDObj, pvRFile, pvType);
      end;
      FCMDObj.S['cmd.namespace'] := 'fileaccess';
      FCMDObj.I['cmd.index'] := 2;   //�ϴ��ļ�

      lvPosition:=lvFileStream.Position;
      FCMDObj.I['start'] := lvPosition;

      lvSize := Min(SEC_SIZE, lvFileStream.Size-lvFileStream.Position);
      if lvSize = 0 then
      begin
        Break;
      end else
      begin
        FCMDObj.ForcePathObject('data').LoadBinaryFromStream(lvFileStream, lvSize);

        FCMDObj.I['size'] := lvSize;
        if (lvFileStream.Position = lvFileStream.Size) then
        begin
          FCMDObj.B['eof'] := true;
        end;

        FCMDStream.Clear;
        FCMDObj.EncodeToStream(FCMDStream);


        TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

        FCMDStream.Clear;
        TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
        FCMDStream.Position := 0;
        FCMDObj.DecodeFromStream(FCMDStream);

        if not FCMDObj.B['__result.result'] then
        begin
          raise Exception.Create(FCMDObj.S['__result.msg']);
        end;

        FPosition := lvFileStream.Position;

        if (lvFileStream.Position = lvFileStream.Size) then
        begin
          Break;
        end;
      end;
    end;
    Result := lvFileStream.Size;
  finally
    lvFileStream.Free;
  end;
end;

class function TFileOperaObject.verifyData(const buf; len: Cardinal): Cardinal;
var
  i:Cardinal;
  p:PByte;
begin
  i := 0;
  Result := 0;
  p := PByte(@buf);
  while i < len do
  begin
    Result := Result + p^;
    Inc(p);
    Inc(i);
  end;
end;

class function TFileOperaObject.verifyStream(pvStream:TStream; len:Cardinal):
    Cardinal;
var
  l, j:Cardinal;
  lvBytes:TBytes;
begin
  SetLength(lvBytes, 1024);

  if len = 0 then
  begin
    j := pvStream.Size - pvStream.Position;
  end else
  begin
    j := len;
  end;

  Result := 0;

  while j > 0 do
  begin
    if j <1024 then l := j else l := 1024;
    
    pvStream.ReadBuffer(lvBytes[0], l);

    Result := Result + verifyData(lvBytes[0], l);
    Dec(j, l);
  end;
end;

end.
