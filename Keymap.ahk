#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\Hotkey.ahk

Hk_PinWindow := new Hotkey(">!>#p")
Hk_PinWindow.onEvent("Fn_PinWindow")

Fn_PinWindow() {
    ShowToolTip("Pin Window", 1000)
    WinGet, CurrentWindow, ID, A
    WinGet, ExStyle, ExStyle, A ; Get the extended styles of the window
    AlwaysOnTop := !!(ExStyle & 0x8) ; Check if the WS_EX_TOPMOST (0x8) flag is set
    if (AlwaysOnTop) {
        WinSet, AlwaysOnTop, Off, ahk_id %CurrentWindow%
        ShowToolTip("Unpin", 1000)
    } else {
        WinSet, AlwaysOnTop, On, ahk_id %CurrentWindow%
    }
}

Hk_TransparencyUp := new Hotkey(">!>#=")
Hk_TransparencyUp.onEvent("Fn_TransparencyUp")
global delta := 3

Fn_TransparencyUp() {
    ShowToolTip("Transparency Up", 1000)
    global delta
    WinGet, CurrentWindow, ID, A
    WinGet, Transparency, Transparent, A ; Get the current transparency
    if (Transparency = "") {
        Transparency = 255
    }
    Transparency += delta
    WinSet, Transparent, %Transparency%, ahk_id %CurrentWindow%
}

Hk_TransparencyDown := new Hotkey(">!>#-")
Hk_TransparencyDown.onEvent("Fn_TransparencyDown")

Fn_TransparencyDown() {
    ShowToolTip("Transparency Down", 1000)
    global delta
    WinGet, CurrentWindow, ID, A
    WinGet, Transparency, Transparent, A ; Get the current transparency
    if (Transparency = "") {
        Transparency = 255
    }
    Transparency -= delta
    WinSet, Transparent, %Transparency%, ahk_id %CurrentWindow%
}

Hk_WinMaximize := new Hotkey(">!>#x")
Hk_WinMaximize.onEvent("Fn_WinMaximize")

Fn_WinMaximize() {
    ShowToolTip("Window Max", 1000)
    SysGet, VirtualWidth, 78
    SysGet, VirtualHeight, 79

    edge := 10
    newWidth := VirtualWidth - (2 * edge)
    newHeight := VirtualHeight - (2 * edge)

    WinGet, activeWindowID, ID, A
    WinMove, ahk_id %activeWindowID%,, edge, edge, newWidth, newHeight
}

Hk_WinCenterOnCursor := new Hotkey(">!>#c")
Hk_WinCenterOnCursor.onEvent("Fn_WinCenterOnCursor")

Fn_WinCenterOnCursor() {
    WinGetPos, WinX, WinY, WinWidth, WinHeight, A
    MouseGetPos, CursorX, CursorY

    CursorX := WinX + CursorX
    CursorY := WinY + CursorY

    NewX := CursorX - (WinWidth / 2)
    NewY := CursorY - (WinHeight / 2)

    WinMove, A,, NewX, NewY
}

Hk_ResetMap := new Hotkey(">!>#Pause")
Hk_ResetMap.onEvent("Fn_ResetMap")

Fn_ResetMap() {
    ShowToolTip("Reset", 1000)
    Run, C:\Users\avons\Code\AHK_Ergodox\_init.ahk
    ExitApp, 3
}

#Include, C:\Users\avons\Code\AHK_Ergodox\Modules\SnapZones.ahk
#Include, C:\Users\avons\Code\AHK_Ergodox\Modules\WindowMark.ahk

snap_set_prefix := "!>^>#"
snap_to_prefix := ">^>#"

mark_set_prefix := "<#>!>#"
mark_focus_prefix := ">!>#"

Loop, 10 {
    number_key := A_Index - 1
    Hk_snap_set := new Hotkey(snap_set_prefix "Numpad" number_key)
    Hk_snap_set.onEvent(Func("SnapZoneFromWindow").Bind(number_key))

    Hk_snap_to := new Hotkey(snap_to_prefix "Numpad" number_key)
    Hk_snap_to.onEvent(Func("SnapWindowToZone").Bind(number_key))

    Hk_mark_set := new Hotkey(mark_set_prefix "Numpad" number_key)
    Hk_mark_set.onEvent(Func("AssignWindowToNumber").Bind(number_key))

    Hk_mark_focus := new Hotkey(mark_focus_prefix "Numpad" number_key)
    Hk_mark_focus.onEvent(Func("FocusWindowByNumber").Bind(number_key))
}


Footpedal_Right := new Hotkey(">#<!PgUp")
Footpedal_Right.onEvent("Count_1")

Count_1() {
    MouseGetPos, CursorX, CursorY
    ShowToolTip("X:" CursorX " Y:" CursorY,80)
}

Footpedal_Left := new Hotkey(">#<!PgDn")
Footpedal_Left.onEvent("Count_2")

Count_2() {
    WinGetPos, WinX, WinY, WinWidth, WinHeight, A
    ShowToolTip("X:" WinX " Y:" WinY " `nW:" WinWidth " H:" WinHeight,80)
}