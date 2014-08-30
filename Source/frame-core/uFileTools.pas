unit uFileTools;

interface

uses
  SysUtils, Classes, Windows, ShlwApi, ShellAPI;

type
  TFileTools = class(TObject)
  public
    class function createTempFileName(strPrefix: string; pvExt: String = '';
        strPath: string = ''): string;

    class function DeleteChars(const s: string; pvCharSets: TSysCharSet): string;

    class function extractFileNameWithoutExt(AFileName: string): string;

    //1 �ж�һ���ļ��Ƿ�����ʹ��
    class function isFileInUse(const FileName: string): boolean;

    //1 ���ݻ���·�������·����ȡ����·��(��ï��)
    class function getAbsolutePath(BasePath, RelativePath: string): string;


    class function getFileNameList(vFileList: TStrings; const aSearchPath: string): integer;
    class function GetWinTempPath: string;

    class function deleteInvalidChar(pvFileName:string): String;


    /// <summary>
    ///   ɾ���ļ����е��ļ�
    /// </summary>
    class function DeleteDirectory(mDirName: string; Ext: String = '*'): Boolean;

    class function FileSize(pvFileName:string): Cardinal;

    class function FileMove(pvSrcFile:String; pvDestFile:String): Boolean;

    class function FileOpen(pvFile:string):Boolean;

    /// <summary>TFileTools.FileRename
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvSrcFile"> �����ļ��� </param>
    /// <param name="pvNewFileName"> ����·���ļ��� </param>
    class function FileRename(pvSrcFile:String; pvNewFileName:string): Boolean;

    class function FileCopy(const ExistingFileName, NewFileName: string;
        ReplaceExisting: Boolean = false): Boolean;

    /// <summary>
    /// ��һ��Ŀ¼
    /// </summary>
    /// <param name="Path"></param>
    class procedure OpenDirectory(const Path:String);
    class function pathWithBackslash(const Path: string): String;
    class function pathWithoutBackslash(const Path: string): string;

    /// <summary>
    /// ��ȡӦ�ó����·��
    /// </summary>
    /// <returns> string
    /// </returns>
    class function getAppPath: string;
  end;

implementation


{$WARN SYMBOL_PLATFORM OFF}
//�õ�һ��Ψһ����ʱ�ļ���,����strPath���Ϊ''�Ļ�,�Զ��õ�windows����ʱ
//�ļ�Ŀ¼.strPrefixΪ��ʱ�ļ���׺.
class function TFileTools.createTempFileName(strPrefix: string; pvExt: String =
    ''; strPath: string = ''): string;
var
  szTempFile: array[0..MAX_PATH] of Char;
  strTempPath: string;
begin
  if strPath = '' then strTempPath := GetWinTempPath
  else strTempPath := strPath;
  GetTempFileName(PChar(strTempPath), PChar(strPrefix), 0, szTempFile);
  result := szTempFile;

  //ɾ����ʱ�ļ�
  DeleteFile(PChar(result));
  if pvExt <> '' then
  begin
    Result := ChangeFileExt(Result, pvExt);
  end;
end;

//   �ַ�����:3.8M 15ns
//   �ַ�����:38.15 M  391ns
//   DeleteChars(pvGUIDKey, ['-', '{','}']);

class function TFileTools.DeleteChars(const s: string; pvCharSets:
    TSysCharSet): string;
var
  i, l, times: Integer;
  lvStr: string;
begin
  l := Length(s);
  SetLength(lvStr, l);
  times := 0;
  for i := 1 to l do
  begin
    if not (s[i] in pvCharSets) then
    begin
      inc(times);
      lvStr[times] := s[i];
    end;
  end;
  SetLength(lvStr, times);
  Result := lvStr;
end;

class function TFileTools.deleteInvalidChar(pvFileName:string): String;
begin
  Result := DeleteChars(pvFileName, ['\', '/']);   
end;

class function TFileTools.DeleteDirectory(mDirName: string; Ext: String = '*'):
    Boolean;
var
  vSearchRec: TSearchRec;
  vPathName, tmpExt: string;
  K: Integer;
begin
  Result := true;

  tmpExt := Ext;
  if Pos('.', tmpExt) = 0 then
    tmpExt := '.' + tmpExt;

  vPathName := mDirName + '\*.*';
  K := FindFirst(vPathName, faAnyFile, vSearchRec);
  while K = 0 do
  begin
    if (vSearchRec.Attr and faDirectory > 0) and
      (Pos(vSearchRec.Name, '..') = 0) then
    begin
      FileSetAttr(mDirName + '\' + vSearchRec.Name, faDirectory);
      Result := DeleteDirectory(mDirName + '\' + vSearchRec.Name, Ext);
    end
    else if Pos(vSearchRec.Name, '..') = 0 then
    begin
      FileSetAttr(mDirName + '\' + vSearchRec.Name, 0);
      if ((CompareText(tmpExt, ExtractFileExt(vSearchRec.Name)) = 0) or (CompareText(tmpExt, '.*') = 0)) then
        Result := DeleteFile(PChar(mDirName + '\' + vSearchRec.Name));
    end;
    if not Result then
      Break;
    K := FindNext(vSearchRec);
  end;
  SysUtils.FindClose(vSearchRec);
end;

class function TFileTools.extractFileNameWithoutExt(AFileName: string): string;
begin
  AFileName := ExtractFileName(AFileName);
  Result := Copy(AFileName, 1, Length(AFileName) - Length(ExtractFileExt(AFileName)));
end;

class function TFileTools.FileCopy(const ExistingFileName, NewFileName: string;
    ReplaceExisting: Boolean = false): Boolean;
begin
  Result := CopyFile(pchar(ExistingFileName), pchar(NewFileName), not ReplaceExisting);
end;

class function TFileTools.FileMove(pvSrcFile:String; pvDestFile:String):
    Boolean;
begin
  Result := MoveFile(pchar(pvSrcFile), pchar(pvDestFile));
end;

class function TFileTools.FileOpen(pvFile: string): Boolean;
begin
  ShellExecute(0, 'open', PChar(pvFile), '', '', SW_NORMAL);
  Result := true;
end;

class function TFileTools.FileRename(pvSrcFile:String; pvNewFileName:string):
    Boolean;
var
  lvNewFile:String;
begin
  lvNewFile := ExtractFilePath(pvSrcFile) + ExtractFileName(pvNewFileName);
  Result := FileMove(pvSrcFile, lvNewFile);
end;

class function TFileTools.FileSize(pvFileName:string): Cardinal;
var
  F: file;
begin
  AssignFile(F, pvFileName);
  try
    Reset(F, 1);
    Result := System.FileSize(F);
  finally
    CloseFile(F);
  end;
end;

class function TFileTools.getFileNameList(vFileList: TStrings; const
    aSearchPath: string): integer;
var dirinfo: TSearchRec;
  dir, lCurrentDir: string;
begin
  result := 0;
  lCurrentDir := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(ParamStr(0)));
  try
    dir := ExtractFilePath(ExpandFileName(aSearchPath));
    if (dir <> '') then
      dir := IncludeTrailingPathDelimiter(dir);

    if (FindFirst(aSearchPath, faArchive, dirinfo) = 0) then repeat
        vFileList.Add(dir + dirinfo.Name);
        Inc(result);
      until (FindNext(dirinfo) <> 0);
    SysUtils.FindClose(dirinfo);
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

class function TFileTools.getAbsolutePath(BasePath, RelativePath: string):
    string;
var
  Dest: array[0..MAX_PATH] of Char;
begin
  FillChar(Dest, SizeOf(Dest), 0);
  PathCombine(Dest, PChar(BasePath), PChar(RelativePath));
  Result := string(Dest);
end;

class function TFileTools.getAppPath: string;
begin
  Result := pathWithBackslash(ExtractFilePath(ParamStr(0)));
end;

//�õ�windows����ʱ�ļ�Ŀ¼
class function TFileTools.GetWinTempPath: string;
var
  szPath: array[0..MAX_PATH] of Char;
  lvBufLen:Cardinal;
begin
  lvBufLen := Length(szPath);
  Windows.GetTempPath(lvBufLen, @szPath[0]);
  result :=StrPas(szPath);
end;

{�ж�һ���ļ��Ƿ�����ʹ��}
class function TFileTools.isFileInUse(const FileName: string): boolean;
var
  HFileRes: HFILE;
begin
  Result := false; {����ֵΪ��(���ļ�����ʹ��)}
  if not FileExists(FileName) then exit; {����ļ����������˳�}
  HFileRes := CreateFile(pchar(FileName), GENERIC_READ or GENERIC_WRITE,
    0 {this is the trick!}, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE); {���CreateFile����ʧ����ôResultΪ��(���ļ����ڱ�ʹ��)}
  if not Result then {���CreateFile���������ǳɹ�}
    CloseHandle(HFileRes); {��ô�رվ��}
end;

class procedure TFileTools.OpenDirectory(const Path:String);
begin
  ShellExecute(0,'open','Explorer.exe',PChar(Path),nil,1);
end;

class function TFileTools.pathWithBackslash(const Path: string): String;
var
  ilen: Integer;
begin
  Result := Path;
  ilen := Length(Result);
  if (ilen > 0) and not (Result[ilen] in ['\', '/']) then
    Result := Result + '\';
end;

class function TFileTools.pathWithoutBackslash(const Path: string): string;
var
  I, ilen: Integer;
begin
  Result := Path;
  ilen := Length(Result);
  for I := ilen downto 1 do
  begin
    if not (Result[I] in ['\', '/', ' ', #13]) then Break;
  end;
  if I <> ilen then
    SetLength(Result, I);
end;

end.
