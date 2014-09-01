unit uMSOSTools;

interface

uses
  Windows, SysUtils,Classes;

type
  TMSSOTools = class(TObject)
  public
    /// <summary>
    ///   �ж�ͬһ���ļ��Ƿ��Ѿ�����
    /// </summary>
    class function CheckAlreadyRun(const pvUniqueStr: string): Boolean;
  end;

implementation

class function TMSSOTools.CheckAlreadyRun(const pvUniqueStr: string): Boolean;
var
  Errno: integer;
  lvUniqueStr, lvFile: string;
  lvHandle:THandle;

  iFileHandle: HFILE;
  Buffer: TOFStruct;
begin
  Result := False;
  lvUniqueStr := pvUniqueStr;
  if lvUniqueStr = '' then raise Exception.Create('CheckAlreadyRunû��ָ��UniqueID');

  //�����ļ�����
  lvFile := ExtractFilePath(ParamStr(0)) + lvUniqueStr + '.unique';

  iFileHandle := OpenFile(PAnsiChar(lvFile), Buffer, OF_CREATE OR Of_Share_Deny_Read);
  if iFileHandle = HFILE_ERROR then
  begin
    Result := true;
  end;
end;

end.
