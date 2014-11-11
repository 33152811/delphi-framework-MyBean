unit uFileOperaObject;

interface

uses
  IdTCPClient, SysUtils, SimpleMsgPack, Classes, Math, uCRCTools,
  uStreamCoderSocket, uZipTools, DTcpClient, uICoderSocket, uDTcpClientCoderImpl;


type
  TFileOperaObject = class(TObject)
  private
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

    property FileCheckSum: Cardinal read FFileCheckSum;

    property FileSize: Int64 read FFileSize;

    
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
  lvFileStream:TFileStream;
  lvRecvObj, lvSendObj:TSimpleMsgPack;
  i, l, lvSize:Integer;
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
var
  i, l, lvSize:Integer;
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
  i, l, lvSize:Integer;
  lvFileName:String;
  lvCrc, lvChecksum, lvLocalCheckSum:Cardinal;
  lvBytes:TBytes;
begin
  checkConnect;
  
  //if FProgConsole <> nil then FProgConsole.SetHintText('���ڻ�ȡԶ���ļ���С');
  readFileINfo(pvRFile, pvType);

  lvRFileSize := FFileSize;

  if lvRFileSize = 0 then Exit;
//  if FProgConsole <> nil then
//  begin
//    FProgConsole.SetMax(lvRFileSize);
//    FProgConsole.SetPosition(0);
//  end;

//  lvCheckSum := FFileCheckSum;
//  if lvCheckSum = 0 then raise Exception.Create('������ļ�������!');

  lvLocalCheckSum := ChecksumAFile(pvLocalFile);
  if lvCheckSum = lvLocalCheckSum then
  begin
//    if FProgConsole <> nil then
//    begin
//      FProgConsole.SetHintText('�봫�ļ�...');
//      FProgConsole.SetPosition(lvRFileSize);
//      Sleep(1000);
//    end;
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
//    if FProgConsole <> nil then
//    begin
//      FProgConsole.SetHintText('�����ļ���...');
//    end;
    while true do
    begin
//      if FProgConsole <> nil then
//      begin
//        if FProgConsole.IsBreaked then Break;
//      end;
        
      FCMDObj.Clear();
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

//      if FProgConsole <> nil then
//      begin
//        FProgConsole.SetPosition(lvFileStream.Position);
//      end;
        
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
  lvCrc:Cardinal;
begin
  result := 0;
  if FileExists(pvFile) then
  begin
    lvFileStream := TFileStream.Create(pvFile, fmOpenRead);
    try
      result := TZipTools.verifyStream(lvFileStream, 0);
    finally
      lvFileStream.Free;
    end;
  end;  
end;

procedure TFileOperaObject.open;
begin
  FTcpClient.Connect;
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
var
  lvFileStream:TFileStream;
  i, l, lvSize:Integer;
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

  lvPosition, i, l, lvSize:Int64;
  lvCheckSum, lvLocalCheckSum:Cardinal;
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
//      if FProgConsole <> nil then
//      begin
//        if FProgConsole.IsBreaked then Break;
//      end;
//
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
//      if lvFileStream.Position = 102400 then
//      begin
//        FCMDObj.I['start'] := lvFileStream.Position;
//      end;
//      if lvFileStream.Position = 0 then
//      begin
//        FCMDObj.I['start'] := 0;
//      end;

//     FCMDObj.S['startStr'] := IntToStr(lvFileStream.Position);
      
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

  //      if FProgConsole <> nil then
  //      begin
  //        FProgConsole.SetPosition(lvFileStream.Position);
  //      end;

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

end.
