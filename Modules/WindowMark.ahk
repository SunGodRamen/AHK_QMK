#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\JSON.ahk
#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\VirtualDesktopAccessor.ahk
#Include, C:\Users\avons\Code\AHK_Ergodox\Util\Tooltip.ahk

; File to store window handles assigned to numbers
global mark_session_repo := "C:\Users\avons\Code\AHK_Ergodox\data\mark_session.json"

; Function to assign the current active window to a number
AssignWindowToNumber(number) {
    session_marks := LoadSessionMarks()
    WinGet, activeHwnd, ID, A ; Get the hwnd (handle) of the active window
    if (activeHwnd) {
        WinGetTitle, winTitle, A
        session_marks[number] := activeHwnd ; Assign the handle to the chosen number
        SaveSessionMarks(session_marks)  
        ShowToolTip(winTitle " mark:" number, 500)
    }
    return
}

; Function to focus on the window assigned to a number
FocusWindowByNumber(number) {
    session_marks := LoadSessionMarks()
    hwnd := session_marks[number]
    if (hwnd) {
        if !WinExist("ahk_id " hwnd) {  ; Check if the window exists
            ; Get the current virtual desktop number
            currentDesktop := GetCurrentDesktopNumber()

            ; Get the virtual desktop number for the window
            windowDesktop := GetWindowDesktopNumber(hwnd)

            if (windowDesktop = -1) {
                ShowToolTip("mark:" number " not found", 800)
                session_marks[number] := ""
                SaveSessionMarks(session_marks)
                return
            } else {
                GoToDesktopNumber(windowDesktop)
            }
        }

        ; Activate the window with the stored handle
        WinActivate, ahk_id %hwnd%
    } else {
        ShowToolTip("X", 200)
    }
    return session_marks
}

; Function to load mark session from file
LoadSessionMarks() {
    if (FileExist(mark_session_repo)) {
        FileRead, mark_file_content, %mark_session_repo%
        session_marks := JSON.Load(mark_file_content)
    } else {
        session_marks := ["","","","","","","","","",""]
    }
    return session_marks
}

; Function to save mark session to a file
SaveSessionMarks(session_marks) {
    FileDelete, %mark_session_repo%
    mark_data := JSON.Dump(session_marks)
    FileAppend, %mark_data%, %mark_session_repo%
    return
}
