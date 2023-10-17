program AbstractMemExplorer;

uses
  Vcl.Forms,
  UFRMAbstractMemExplorer in 'src\UFRMAbstractMemExplorer.pas' {FRMAbstractMemExplorer},
  UAbstractStorage in '..\..\src\UAbstractStorage.pas',
  UAbstractAVLTree in '..\..\src\UAbstractAVLTree.pas',
  UAbstractBTree in '..\..\src\UAbstractBTree.pas',
  UAbstractMem in '..\..\src\UAbstractMem.pas',
  UAbstractMemBTree in '..\..\src\UAbstractMemBTree.pas',
  UAbstractMemTList in '..\..\src\UAbstractMemTList.pas',
  UAVLCache in '..\..\src\UAVLCache.pas',
  UCacheMem in '..\..\src\UCacheMem.pas',
  UFileMem in '..\..\src\UFileMem.pas',
  UOrderedList in '..\..\src\UOrderedList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFRMAbstractMemExplorer, FRMAbstractMemExplorer);
  Application.Run;
end.
