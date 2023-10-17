program AbstractMem.Tests;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

// Enable for Console tests
{.$DEFINE CONSOLE_TESTRUNNER}

{$IFDEF CONSOLE_TESTRUNNER}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF FPC}
  {$IFDEF CONSOLE_TESTRUNNER}
  Classes,
  {$ELSE}
  Interfaces,
  Forms, GuiTestRunner,
  {$ENDIF }
  {$ELSE}
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  {$ENDIF }
  UAbstractAVLTree in '..\src\UAbstractAVLTree.pas',
  UAbstractBTree in '..\src\UAbstractBTree.pas',
  UAbstractMem in '..\src\UAbstractMem.pas',
  UAbstractMemBTree in '..\src\UAbstractMemBTree.pas',
  UAbstractMemTList in '..\src\UAbstractMemTList.pas',
  UMemoryBTreeData in '..\src\UMemoryBTreeData.pas',
  UAVLCache in '..\src\UAVLCache.pas',
  UCacheMem in '..\src\UCacheMem.pas',
  UFileMem in '..\src\UFileMem.pas',
  UOrderedList in '..\src\UOrderedList.pas',
  UAbstractStorage in '..\src\UAbstractStorage.pas',
  UCacheMem.Tests in 'src\UCacheMem.Tests.pas',
  UAbstractMem.Tests in 'src\UAbstractMem.Tests.pas',
  UAbstractBTree.Tests in 'src\UAbstractBTree.Tests.pas',
  UAbstractMemBTree.Tests in 'src\UAbstractMemBTree.Tests.pas',
  UAbstractMemTList.Tests in 'src\UAbstractMemTList.Tests.pas',
  UFileMem.Tests in 'src\UFileMem.Tests.pas',
  UAbstractStorage.Tests in 'src\UAbstractStorage.Tests.pas',
  UMemoryBTreeData.Tests in 'src\UMemoryBTreeData.Tests.pas';

{$IF Defined(FPC) and (Defined(CONSOLE_TESTRUNNER))}
type
  TFreePascalConsoleRunner = class(TTestRunner)
  protected
  end;
var
  Application : TFreePascalConsoleRunner;
{$ENDIF}

begin
  {$IFNDEF FPC}
  System.ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  {$IF Defined(FPC) and (Defined(CONSOLE_TESTRUNNER))}
  Application := TFreePascalConsoleRunner.Create(nil);
  {$ENDIF}

  Application.Title:='Test';
  Application.Initialize;
  {$IFDEF FPC}
  {$IF Not Defined(CONSOLE_TESTRUNNER)}
  Application.CreateForm(TGuiTestRunner, TestRunner);
  {$ENDIF}
  Application.Run;
  {$ELSE}
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
  {$ENDIF}
end.


