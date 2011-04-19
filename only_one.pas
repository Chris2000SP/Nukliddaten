unit only_one;

interface

implementation

uses Forms, windows;

var mutex : THandle;
    h     : HWnd;


initialization
  mutex := CreateMutex(nil, True, 'NukDatMutex');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
     h := 0;
     repeat
       h := FindWindowEx(0, h, 'TApplication', PChar(Application.Title))
     until h <> Application.Handle;
     if h <> 0 then
     begin
        Windows.ShowWindow(h, SW_ShowNormal);
        windows.SetForegroundWindow(h);
     end;
     Halt;
  end;
finalization
  ReleaseMutex(mutex);
end.
