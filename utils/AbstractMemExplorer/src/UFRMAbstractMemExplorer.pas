unit UFRMAbstractMemExplorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  {$IFNDEF FPC}System.Generics.Collections,System.Generics.Defaults,{$ELSE}Generics.Collections,Generics.Defaults,{$ENDIF}
  UAbstractMem, UFileMem, UAbstractBTree, UOrderedList, UAbstractStorage;

type

  TAbstractMemAnalyzer = class
  private
    FAbstractMemZoneInfoList : TList<TAbstractMemZoneInfo>;
    FOrderedByMemSize: TMemoryBTree<Integer>;
    FMemLeaksOrderedByMemSize: TMemoryBTree<Integer>;
    FUsedMemOrderedByMemSize: TMemoryBTree<Integer>;
    function GetItem(index: integer): TAbstractMemZoneInfo;
    function TComparison_ByMemSize2(const ALeft, ARight: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Count : Integer;
    property Items[index:integer]:TAbstractMemZoneInfo read GetItem;
    property OrderedByMemSize : TMemoryBTree<Integer> read FOrderedByMemSize;
    property MemLeaksOrderedByMemSize : TMemoryBTree<Integer> read FMemLeaksOrderedByMemSize;
    property UsedMemOrderedByMemSize : TMemoryBTree<Integer> read FUsedMemOrderedByMemSize;
    procedure Add(const AAbstractMemZoneInfo : TAbstractMemZoneInfo);
    property AbstractMemZoneInfoList : TList<TAbstractMemZoneInfo> read FAbstractMemZoneInfoList;
    procedure Reorg;
  end;

  TFRMAbstractMemExplorer = class(TForm)
    pnlTop: TPanel;
    bbSelectFilename: TButton;
    lblFileName: TLabel;
    memoInfo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure bbSelectFilenameClick(Sender: TObject);
    procedure bbCreateRandomClick(Sender: TObject);
  private
    { Private declarations }
    procedure AnalyzeAbstractMem(const AAbstractMem : TAbstractMem);
  public
    { Public declarations }
  end;

var
  FRMAbstractMemExplorer: TFRMAbstractMemExplorer;

implementation

{$R *.dfm}

procedure TFRMAbstractMemExplorer.AnalyzeAbstractMem(
  const AAbstractMem: TAbstractMem);
var LAbstractMemZoneInfoList : TAbstractMemAnalyzer; //TList<TAbstractMemZoneInfo>;
  LTotalUsedSize, LTotalUsedBlocksCount, LTotalLeaksSize, LTotalLeaksBlocksCount : Int64;
  LStrings : TStrings;
  i, LBroCount, LBroSize : Integer;
  LBroStartPos, LlastInfo : TAbstractMemZoneInfo;
  LAbstractStorage : TAbstractStorage;

  procedure IsDifferent;
  var s : String;
  begin
    if (LBroStartPos.ZoneType=amzt_used) then begin
      s:='USED MEMORY';
      Exit; // Not print
    end
    else s := 'MEMORY LEAK';
    LStrings.Add(Format('%d %s from %d to %d total %d',[LBroCount,s,LBroStartPos.AMZone.position,LLastInfo.AMZone.position+LLastInfo.AMZone.size, LLastInfo.AMZone.position - LBroStartPos.AMZone.position + LLastInfo.AMZone.size ] ));
  end;
begin
  LStrings := TStringList.Create;
  LAbstractMemZoneInfoList := TAbstractMemAnalyzer.Create; // TList<TAbstractMemZoneInfo>.Create;
  Try
    LAbstractStorage := TAbstractStorage.Create(AAbstractMem,'',0,Nil);
    try
      if LAbstractStorage.IsValidAbstractStorage then begin      
        LAbstractStorage.Analize(LStrings);
        LStrings.Add('');
      end;
    finally
      LAbstractStorage.Free;
    end;

    If Not AAbstractMem.CheckConsistency(Nil,LAbstractMemZoneInfoList.AbstractMemZoneInfoList,
      LTotalUsedSize, LTotalUsedBlocksCount, LTotalLeaksSize, LTotalLeaksBlocksCount) then begin
      LStrings.Add('Not a valid AbstractMem');
      Exit;
    end;
    LStrings.Add('AbstractMem info of usage:');
    LAbstractMemZoneInfoList.Reorg;
    i := 0;
    LBroCount := 0;
    LBroSize := 0;
    LlastInfo.AMZone.Clear;
    LlastInfo.ZoneType := amzt_unknown;
    while (i<LAbstractMemZoneInfoList.Count) do begin
      if (i=0) or (LAbstractMemZoneInfoList.Items[i].ZoneType = LlastInfo.ZoneType) then begin
        if (i=0) then begin
          LBroStartPos := LAbstractMemZoneInfoList.Items[i];
        end;
        Inc(LBroCount);
        Inc(LBroSize,LAbstractMemZoneInfoList.Items[i].AMZone.size);
      end else begin
        // Write result
        IsDifferent;
        LBroStartPos := LAbstractMemZoneInfoList.Items[i];
        LBroSize := LBroStartPos.AMZone.size;
        LBroCount := 1;
      end;
      LlastInfo := LAbstractMemZoneInfoList.Items[i];
      inc(i);
    end;
    if (i>0) then IsDifferent;
    //
    //
    LStrings.Add(Format('TotalUsedSize:%d TotalUsedBlocksCount:%d TotalLeaksSize:%d TotalLeaksBlocksCount:%d',
      [LTotalUsedSize, LTotalUsedBlocksCount, LTotalLeaksSize, LTotalLeaksBlocksCount]));

    if LAbstractMemZoneInfoList.MemLeaksOrderedByMemSize.FindLowest(i) then begin
      LlastInfo := LAbstractMemZoneInfoList.Items[i];
      LBroCount := 1;
      while (LAbstractMemZoneInfoList.MemLeaksOrderedByMemSize.FindSuccessor(i,i)) do begin
        LBroStartPos := LAbstractMemZoneInfoList.Items[i];
        if LBroStartPos.AMZone.size=LlastInfo.AMZone.size then inc(LBroCount)
        else begin
          LStrings.Add(Format('MEM LEAK size %d count:%d',[LLastInfo.AMZone.size,LBroCount]));
          LLastInfo := LBroStartPos;
          LBroCount := 1;
        end;
      end;
      LStrings.Add(Format('MEM LEAK size %d count:%d',[LLastInfo.AMZone.size,LBroCount]));
    end;

    if LAbstractMemZoneInfoList.UsedMemOrderedByMemSize.FindLowest(i) then begin
      LlastInfo := LAbstractMemZoneInfoList.Items[i];
      LBroCount := 1;
      while (LAbstractMemZoneInfoList.UsedMemOrderedByMemSize.FindSuccessor(i,i)) do begin
        LBroStartPos := LAbstractMemZoneInfoList.Items[i];
        if LBroStartPos.AMZone.size=LlastInfo.AMZone.size then inc(LBroCount)
        else begin
          LStrings.Add(Format('USED size %d count:%d',[LLastInfo.AMZone.size,LBroCount]));
          LLastInfo := LBroStartPos;
          LBroCount := 1;
        end;
      end;
      LStrings.Add(Format('USED size %d count:%d',[LLastInfo.AMZone.size,LBroCount]));
    end;
  Finally
    memoInfo.Lines.BeginUpdate;
    try
      for i := 0 to LStrings.Count-1 do begin
        memoInfo.Lines.Add(LStrings[i]);
      end;
    finally
      memoInfo.Lines.EndUpdate;
    end;
    LStrings.Free;
    LAbstractMemZoneInfoList.Free;
  End;
end;

procedure TFRMAbstractMemExplorer.bbCreateRandomClick(Sender: TObject);
begin
  // This will generate a Random file
end;

procedure TFRMAbstractMemExplorer.bbSelectFilenameClick(Sender: TObject);
var Lod : TOpenDialog;
  Lfm : TFileMem;
begin
  Lod := TOpenDialog.Create(Self);
  try
    Lod.Filter:='AbstractMem files (*.am*)|*.am*|Abstract Storage files (*.ams)|*.ams|All files (*.*)|*.*';
    if Not Lod.Execute then Exit;
    lblFileName.Caption := Lod.FileName;
    Lfm := TFileMem.Create(Lod.FileName,True);
    try
      AnalyzeAbstractMem(Lfm);
      memoInfo.Lines.Insert(0,'Analyzing file: '+Lod.FileName);
    finally
      Lfm.Free;
    end;
  finally
    Lod.Free;
  end;
end;

procedure TFRMAbstractMemExplorer.FormCreate(Sender: TObject);
begin
  //
  lblFileName.Caption := '';
  memoInfo.Lines.Clear;
end;

{ TAbstractMemAnalyzer }

procedure TAbstractMemAnalyzer.Add(const AAbstractMemZoneInfo: TAbstractMemZoneInfo);
begin
  FAbstractMemZoneInfoList.Add(AAbstractMemZoneInfo);
  FOrderedByMemSize.Add(FAbstractMemZoneInfoList.Count-1);
  if AAbstractMemZoneInfo.ZoneType=amzt_memory_leak then FMemLeaksOrderedByMemSize.Add(FAbstractMemZoneInfoList.Count-1)
  else if AAbstractMemZoneInfo.ZoneType=amzt_used then FUsedMemOrderedByMemSize.Add(FAbstractMemZoneInfoList.Count-1);
end;

function TAbstractMemAnalyzer.Count: Integer;
begin
  Result := FAbstractMemZoneInfoList.Count;
end;

constructor TAbstractMemAnalyzer.Create;
begin
  FOrderedByMemSize:= TMemoryBTree<Integer>.Create(TComparison_ByMemSize2,True,5);
  FAbstractMemZoneInfoList := TList<TAbstractMemZoneInfo>.Create;
  FMemLeaksOrderedByMemSize:= TMemoryBTree<Integer>.Create(TComparison_ByMemSize2,True,5);
  FUsedMemOrderedByMemSize:= TMemoryBTree<Integer>.Create(TComparison_ByMemSize2,True,5);
end;

destructor TAbstractMemAnalyzer.Destroy;
begin
  FOrderedByMemSize.Free;
  FAbstractMemZoneInfoList.Free;
  FMemLeaksOrderedByMemSize.Free;
  FUsedMemOrderedByMemSize.Free;
  inherited;
end;

function TAbstractMemAnalyzer.GetItem(index: integer): TAbstractMemZoneInfo;
begin
  Result := FAbstractMemZoneInfoList.Items[index];
end;

procedure TAbstractMemAnalyzer.Reorg;
var i : Integer;
begin
  FOrderedByMemSize.EraseTree;
  FMemLeaksOrderedByMemSize.EraseTree;
  FUsedMemOrderedByMemSize.EraseTree;
  for i:=0 to Count-1 do begin
    FOrderedByMemSize.Add(i);
    if FAbstractMemZoneInfoList.Items[i].ZoneType=amzt_memory_leak then FMemLeaksOrderedByMemSize.Add(i)
    else if FAbstractMemZoneInfoList.Items[i].ZoneType=amzt_used then FUsedMemOrderedByMemSize.Add(i);
  end;
end;

function TAbstractMemAnalyzer.TComparison_ByMemSize2(const ALeft, ARight: Integer): Integer;
begin
  Result := FAbstractMemZoneInfoList.Items[ALeft].AMZone.size - FAbstractMemZoneInfoList.Items[ARight].AMZone.size;
  if Result=0 then begin
    Result := FAbstractMemZoneInfoList.Items[ALeft].AMZone.position - FAbstractMemZoneInfoList.Items[ARight].AMZone.position;
  end;
end;

end.
