unit uSOTools;

interface

uses
  superobject, SysUtils, Classes, Variants;

type
  TSOTools = class(TObject)
  public
    /// <summary>
    ///   ���ļ��н���
    /// </summary>
    class function JsnParseFromFile(pvFile: string): ISuperObject;

    /// <summary>
    ///   ��pvData���ݱ��浽�ļ���
    /// </summary>
    class function JsnSaveToFile(pvData: ISuperObject; pvFile: string): Boolean;

  end;

implementation


class function TSOTools.JsnParseFromFile(pvFile: string): ISuperObject;
var
  lvStream: TMemoryStream;
  lvStr: AnsiString;
begin
  Result := nil;
  if FileExists(pvFile) then
  begin
    lvStream := TMemoryStream.Create;
    try
      lvStream.LoadFromFile(pvFile);
      lvStream.Position := 0;
      SetLength(lvStr, lvStream.Size);
      lvStream.ReadBuffer(lvStr[1], lvStream.Size);
      Result := SO(lvStr);
    finally
      lvStream.Free;
    end;
  end;
  if Result <> nil then
    if not (Result.DataType in [stArray, stObject]) then
      Result := nil;
end;

class function TSOTools.JsnSaveToFile(pvData: ISuperObject; pvFile: string):
    Boolean;
var
  lvStrings: TStrings;
  lvStream: TMemoryStream;

  lvStr: AnsiString;
begin
  Result := false;
  if pvData = nil then exit;
  lvStream := TMemoryStream.Create;
  try
    lvStr := pvData.AsJSon(True, False);
    if lvStr <> '' then
      lvStream.WriteBuffer(lvStr[1], Length(lvStr));
    lvStream.SaveToFile(pvFile);
    Result := true;
  finally
    lvStream.Free;
  end;
end;


end.

