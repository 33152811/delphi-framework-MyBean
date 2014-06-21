unit uReportConsoleObject;

interface

uses
  uIReporter, uIFileAccess, Forms, ufrmReportList, SysUtils,
  FileLogger;

type
  TReportConsoleObject = class(TInterfacedObject, IReportConsole)
  private
    FLastMessage:String;
    FFileAccess:IFileAccess;
    FConfig:String;
    FDataList:IInterface;
    FReportList: TfrmReportList;
    FReportID:String;
  public
    constructor Create;
    destructor Destroy; override;
    //��ӡ����,���뵥�������ID
    procedure Print(pvID:PAnsiChar);stdcall;   //��ӡĬ�ϱ���

    //Ԥ������,���뵥�������ID (��������Ϊ��ֵ,��Ԥ����һ��)
    procedure PreView(pvID:PAnsiChar);stdcall;

    //��Ʊ���,���뵥�������ID (��������Ϊ��ֵ,��Ԥ����һ��)
    procedure Design(pvID: PAnsiChar); stdcall;

    //���ݱ���ID,��ȡһ������ (��������Ϊ��ֵ,��Ԥ����һ��)
    function createReporter(pvID: PAnsiChar): IReporter; stdcall;

    // <summary>
    //   ��ȡ�����б�
    // </summary>
    // <returns>
    // [
    //    {caption:xxx,ID:xxxx},
    //    {caption:xxx,ID:xxxx}
    // ]
    // </returns>
    function getReports: PAnsiChar; stdcall;

    //���汨���ļ�
    function saveFileRes(pvID: PAnsiChar): PAnsiChar; stdcall;

    //��ȡ������Ϣ
    function getReportINfo(pvID:PAnsiChar):PAnsiChar; stdcall;

    //���һ���µı���,������ƺõı���ID
    function DesignNewReport(pvTypeID:PAnsiChar; pvRepName:PAnsiChar):PAnsiChar;stdcall;

    //��ȡ��һ��ID
    function getFirstReporterID():PAnsiChar;stdcall;

    //��ʾ����̨
    procedure ShowConsole();

    //׼������
    procedure Prepare;stdcall;

    //�ͷſ���
    procedure FreeConsole();

    //��������
    procedure setConfig(pvConfig:PAnsiChar);stdcall;
    
    //���ñ����б�ID,���ݸ�IDȥ���ұ����б�
    procedure setReportID(pvReportID:PAnsiChar);stdcall;

    //���ݶ���Ľӿ��б�
    procedure setDataList(const pvIntf: IInterface); stdcall;

    //�ļ������ӿ�
    procedure setFileAccess(const pvIntf: IFileAccess); stdcall;
  end;

implementation

constructor TReportConsoleObject.Create;
begin
  inherited Create;
  FReportList:=TfrmReportList.Create(nil);
end;

destructor TReportConsoleObject.Destroy;
begin
  FReportList.Free;
  FFileAccess := nil;
  inherited Destroy;
end;

{ TReportConsoleObject }

function TReportConsoleObject.createReporter(pvID: PAnsiChar): IReporter;
begin
  
end;

procedure TReportConsoleObject.Design(pvID: PAnsiChar);
begin

end;

function TReportConsoleObject.DesignNewReport(pvTypeID,
  pvRepName: PAnsiChar): PAnsiChar;
begin

end;

procedure TReportConsoleObject.FreeConsole;
begin

end;

function TReportConsoleObject.getFirstReporterID: PAnsiChar;
begin

end;

function TReportConsoleObject.getReportINfo(pvID: PAnsiChar): PAnsiChar;
begin

end;

function TReportConsoleObject.getReports: PAnsiChar;
begin

end;

procedure TReportConsoleObject.Prepare;
begin

end;

procedure TReportConsoleObject.PreView(pvID: PAnsiChar);
begin

end;

procedure TReportConsoleObject.Print(pvID: PAnsiChar);
begin

end;

function TReportConsoleObject.saveFileRes(pvID: PAnsiChar): PAnsiChar;
begin

end;

procedure TReportConsoleObject.setConfig(pvConfig: PAnsiChar);
begin
  FConfig := pvConfig;
end;

procedure TReportConsoleObject.setDataList(const pvIntf: IInterface);
begin
  FDataList := pvIntf;
end;

procedure TReportConsoleObject.setFileAccess(const pvIntf: IFileAccess);
begin
  FFileAccess := pvIntf;
end;

procedure TReportConsoleObject.setReportID(pvReportID: PAnsiChar);
begin
  FReportID := pvReportID;
end;

procedure TReportConsoleObject.ShowConsole;
begin
  try
    FReportList.setFileAccess(FFileAccess);
    FReportList.setDataList(FDataList);
    FReportList.setConfig(PAnsiChar(FConfig));
    FReportList.setReportID(PAnsiChar(FReportID));
    FReportList.ShowConsole();
  except
    on E:Exception do
    begin
      FLastMessage:= E.Message;
      TFileLogger.instance.logErrMessage(E.Message);    
    end;
  end;
end;

end.
