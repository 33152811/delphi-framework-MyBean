unit DMQProtocol;

interface

const
  cmd_none     = 0;         //
  cmd_kickout  = 2;         // ֪ͨ�ߵ�����
  cmd_send     = 3;         // ����
  cmd_registerDispatch = 4; // ע���߼�����


const
  result_Decode_succ       = 1;
  result_Decode_none       = 2;  // û�п��Խ��������
  result_Decode_error      = 3;  // �����쳣

type
  // �߼����������������ݽṹ
  // ������� -> DMQ���� �����ݽṹ
  PDMQDispatchRequestRecord = ^TDMQDispatchRequestRecord;
  TDMQDispatchRequestRecord = packed record
    flag        : Word;
    cmdIndex    : Word;
    remoteSocketHandle: THandle;     // Զ��socket���
    remoteContextDNA  : Integer;     // ContextDNA
    datalen     : Integer;
  end;



  // DMQ���� -> ������̵����ݽṹ
  TDMQDispatchRecord = packed record
    flag        : Word;
    remoteSocketHandle: THandle;     // Զ��socket���
    remoteContextDNA  : Integer;     // ContextDNA
    datalen     : Integer;
  end;

  // �ն� -> DMQ���� �����ݽṹ
  TDMQRequestRecord = packed record
    flag       : word;
    logicID    : word;     // �߼�������ID
    datalen    : Integer;  // ���ݳ���
  end;

  // �ն� -> DMQ���� �����ݽṹ
  TDMQResponseRecord = packed record
    flag       : word;
    datalen    : Integer;  // ���ݳ���
  end;

const
  TDMQRequestRecordSize = SizeOf(TDMQRequestRecord);
  TDMQDispatchRequestRecordSize = SizeOf(TDMQDispatchRequestRecord);

const
  Header_Flag = $D10;

implementation

end.
