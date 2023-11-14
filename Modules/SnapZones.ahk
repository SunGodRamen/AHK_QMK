#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\JSON.ahk
#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\VirtualDesktopAccessor.ahk
#Include, C:\Users\avons\Code\AHK_Ergodox\Util\Tooltip.ahk

global snap_zone_repo := "C:\Users\avons\Code\AHK_Ergodox\data\snap_zones.json"

; Use active window location and dimensions to record a new snap zone associated with the hotkey number
SnapZoneFromWindow(number) {
    snap_zones := LoadSnapZones()
    WinGetPos, x, y, w, h, A ; Get the position and dimensions of the active window
    snap_zones[number] := { "x": x, "y": y, "w": w, "h": h }
    SaveSnapZones(snap_zones)
    ShowToolTip("Snap zone " number, 3000)
}

; Snap active window to previously recorded position
SnapWindowToZone(number) {
    snap_zones := LoadSnapZones()
    zone := snap_zones[number]
    if (zone) {
        ; Move and resize the active window to the recorded position and dimensions
        WinMove, A,, % zone.x, % zone.y, % zone.w, % zone.h
    }
}

; Function to load snap zones from file
LoadSnapZones() {
    if (FileExist(snap_zone_repo)) {
        FileRead, snap_zones_content, %snap_zone_repo%
        snap_zones := JSON.Load(snap_zones_content)
    } else {
        snap_zones := ["","","","","","","","","",""]
    }
    Return snap_zones
}

; Function to save snap zones to a file
SaveSnapZones(snap_zones) {
    FileDelete, %snap_zone_repo%
    snap_zone_data := JSON.Dump(snap_zones)
    FileAppend, %snap_zone_data%, %snap_zone_repo%
}