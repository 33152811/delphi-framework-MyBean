unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, StdCtrls, ExtCtrls, DB, DBClient,
  Grids, DBGrids, uIFileAccess;

type
  TfrmPluginForm = class(TBasePluginForm)
    pnlOperator: TPanel;
    btnPreView: TButton;
    btnDesign: TButton;
    btnPrint: TButton;
    cbbUser: TComboBox;
    DBGrid1: TDBGrid;
    cdsMain: TClientDataSet;
    cdsMainFKey: TStringField;
    cdsMainFCode: TStringField;
    cdsMainFName: TStringField;
    cdsMainFUpbuildTime: TDateTimeField;
    dsMain: TDataSource;
    Label1: TLabel;
    procedure btnDesignClick(Sender: TObject);
    procedure btnPreViewClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    FFileAccess: IFileAccess;
    FDataIntf: IInterfaceList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); override; stdcall;
  end;

var
  frmPluginForm: TfrmPluginForm;

implementation

uses
  mBeanFrameVars, uIPluginForm, uLocalFileAccess, uIReporter, ComObj,
  uDataSetWrapper, uErrorINfoTools;

{$R *.dfm}

constructor TfrmPluginForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ///��ʾ����
  cdsMain.Append;
  cdsMain.FieldByName('FKey').AsString := CreateClassID;
  cdsMain.FieldByName('FCode').AsString := '001';
  cdsMain.FieldByName('FName').AsString := '����';
  cdsMain.FieldByName('FUpbuildTime').AsDateTime := Now();
  cdsMain.Append;
  cdsMain.FieldByName('FKey').AsString := CreateClassID;
  cdsMain.FieldByName('FCode').AsString := '002';
  cdsMain.FieldByName('FName').AsString := '����';
  cdsMain.FieldByName('FUpbuildTime').AsDateTime := Now();
  cdsMain.Post;


  /// �����ļ��洢�ӿ�
  FFileAccess := TLocalFileAccess.Create(ExtractFilePath(ParamStr(0)) + '\Files');

  /// �����ṩ�ӿ�
  FDataIntf := TInterfaceList.Create;

  // �ṩ����ӡ��һ����ʾ���ݼ�
  FDataIntf.Add(TDataSetWrapper.Create(cdsMain));
end;

destructor TfrmPluginForm.Destroy;
begin
  FDataIntf.Clear;
  FDataIntf := nil;
  inherited Destroy;
end;

procedure TfrmPluginForm.btnDesignClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //�����ļ��Ĵ洢, �����滻��DB,����FTP���ļ������ӿ�
    lvConsole.setFileAccess(FFileAccess);

    //��������ID,���ڱ����б�Ĵ洢�ͻ�ȡ
    lvConsole.setReportID('1002579');

    //������Ϣ
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //��ӡ�����ṩ�ӿ�
    lvConsole.setDataList(FDataIntf);

    //׼������
    lvConsole.Prepare;

    //��ʾ����̨
    lvConsole.ShowConsole;

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;
//  with TReportConsoleLibWrapper.createReportConsole do
//  try
//    setFileAccess(FFileAccess);
//    setDataList(FDataIntf);
//    setReportID('1002579');
//    lvID := getFirstReporterID;
//    if lvID <> '' then
//    begin
//      Design(PAnsiChar(lvID));
//    end else
//    begin
//      DesignNewReport('RM', '��׼����');
//    end;
//  finally
//    FreeConsole;
//  end;

end;

procedure TfrmPluginForm.btnPreViewClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //�����ļ��Ĵ洢, �����滻��DB,����FTP���ļ������ӿ�
    lvConsole.setFileAccess(FFileAccess);

    //��������ID,���ڱ����б�Ĵ洢�ͻ�ȡ
    lvConsole.setReportID('1002579');

    //������Ϣ
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //��ӡ�����ṩ�ӿ�
    lvConsole.setDataList(FDataIntf);

    //׼������
    lvConsole.Prepare;

    //��ʾԤ��
    lvConsole.PreView('');

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;

end;

procedure TfrmPluginForm.btnPrintClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //�����ļ��Ĵ洢, �����滻��DB,����FTP���ļ������ӿ�
    lvConsole.setFileAccess(FFileAccess);

    //��������ID,���ڱ����б�Ĵ洢�ͻ�ȡ
    lvConsole.setReportID('1002579');

    //������Ϣ
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //��ӡ�����ṩ�ӿ�
    lvConsole.setDataList(FDataIntf);

    //׼������
    lvConsole.Prepare;

    //��ӡ
    lvConsole.Print('');

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;

end;

procedure TfrmPluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  inherited;
  ;
end;

end.
