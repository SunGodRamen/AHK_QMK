#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\JSON.ahk

config_file_path := C:\Users\avons\Code\AHK_Ergodox\config.json
FileRead, config_contents, %config_file_path%
global config := JSON.Load(config_contents)

#Include, C:\Users\avons\Code\AHK_Ergodox\Keymap.ahk
