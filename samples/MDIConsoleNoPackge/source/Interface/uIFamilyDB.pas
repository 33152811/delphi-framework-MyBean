unit uIFamilyDB;

interface

type

  { Ϊ����Ŀ¼�洢�ڵ���Ϣ . }
  TPersonData = record
    Name: string;
    Level: Integer;         //����
    LevelWord: string;      //����
    ListNum: Integer;        //����
    FatherID: Int64;
    BranchID: Integer;     //֧��ID
    IconIdx: Integer;
  end;
  PPersonData = ^TPersonData;



  {֧����Ϣ}
  TBranchData = record
    ID   :integer;
    Name :string;
    Addr :string;        //��ַ
    Level :integer;      //����
    Note  :string;
    ParentID :integer;    //�ϴ�֧��
    Icon  :string;    //ͼ������
  end;
  PBranchData = ^TBranchData;
  
  IFamilyDB = Interface
    ['{7A52B781-DAB2-48F2-9418-B27E0AD6521B}']
    function CreateDatabaseFile(const pvFilename: PAnsiChar): boolean; stdcall;
    function OpenDatabase(const pvFilename: PAnsiChar): boolean; stdcall;
    function CloseDatabase:boolean; stdcall;

    //��Ա����
    function AddPersonData(const aPersonData :PPersonData):Int64;stdcall; //����ID
    function GetPersonData(const AID:Int64):PPersonData;stdcall;

    //Branch����
    function GetBranchData(const AID:Int64):PBranchData;stdcall;
    function AddBranchData(const aBranchData :PBranchData):Int64;stdcall; //����ID
    function UpdateBranchData(const aBranchData :PBranchData):Int64;stdcall; //����ID


     //ΪTreeView��ѯ���ݶ�����
     //׼��һ������ָ��������¼ID�еĲ�ѯ
     function PrepareQueryIDStatment(SQL:PAnsiChar):boolean;stdcall;  //׼����ѯ���
     function QueryIDStatmentStep():Int64;stdcall; //����ID ,��û�м�¼�򷵻�-1

  End;


  

implementation

end.
