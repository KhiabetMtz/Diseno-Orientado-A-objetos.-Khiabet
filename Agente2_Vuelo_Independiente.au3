; Agente 2 - Manejo independiente de vuelo
; Controla 3 a ;eviones en GeoFS: Boeing737, Cessna172, PiperCub
; F12 para detener en cualquier momento

HotKeySet("{F12}", "Detener")
Func Detener()
   MsgBox(0, "Agente", "Vuelo cancelado.")
   Exit
EndFunc

; funciones
Func Presionar($vk)
   DllCall("user32.dll", "none", "keybd_event", "byte", $vk, "byte", 0, "dword", 0, "ulong_ptr", 0)
EndFunc

Func Soltar($vk)
   DllCall("user32.dll", "none", "keybd_event", "byte", $vk, "byte", 0, "dword", 2, "ulong_ptr", 0)
EndFunc

Func Mantener($vk, $ms)
   Presionar($vk)
   Sleep($ms)
   Soltar($vk)
   Sleep(200)
EndFunc

; codigos de teclas
Global Const $VK_W = 0x57
Global Const $VK_S = 0x53
Global Const $VK_K = 0x4B
Global Const $VK_I = 0x49
Global Const $VK_Q = 0x51
Global Const $VK_E = 0x45
Global Const $VK_A = 0x41
Global Const $VK_G = 0x47
Global Const $VK_B = 0x42

; variables
Global $T_pista, $T_rotar, $T_subida, $T_vuelo, $T_bajar, $T_final
Global $T_flare, $T_freno, $T_accel
Global $flaps_dep, $flaps_ate, $tren, $spoilers, $autopilot

; elegir avion
Local $opcion = MsgBox(3, "Seleccionar Aeronave", _
   "SI = Boeing 737" & @CRLF & _
   "NO = Cessna 172" & @CRLF & _
   "CANCELAR = Piper Cub")

Local $seccion = ""
Local $idAvion = ""
Local $urlAvion = ""

If $opcion = 6 Then
   $seccion = "Boeing737"
   $idAvion = "Boeing 737"
   $urlAvion = "4"
ElseIf $opcion = 7 Then
   $seccion = "Cessna172"
   $idAvion = "Cessna 172"
   $urlAvion = "2"
Else
   $seccion = "PiperCub"
   $idAvion = "Piper Cub"
   $urlAvion = "1"
EndIf

; leer parametros .ini
Local $ruta = @ScriptDir & "\config.ini"
$T_pista   = Int(IniRead($ruta, $seccion, "T_pista",   5000))
$T_rotar   = Int(IniRead($ruta, $seccion, "T_rotar",   2000))
$T_subida  = Int(IniRead($ruta, $seccion, "T_subida",  4000))
$T_vuelo   = Int(IniRead($ruta, $seccion, "T_vuelo",  20000))
$T_bajar   = Int(IniRead($ruta, $seccion, "T_bajar",   6000))
$T_final   = Int(IniRead($ruta, $seccion, "T_final",   4000))
$T_flare   = Int(IniRead($ruta, $seccion, "T_flare",   1500))
$T_freno   = Int(IniRead($ruta, $seccion, "T_freno",   4000))
$T_accel   = Int(IniRead($ruta, $seccion, "T_accel",   3000))
$flaps_dep = Int(IniRead($ruta, $seccion, "flaps_dep",    0))
$flaps_ate = Int(IniRead($ruta, $seccion, "flaps_ate",    0))
$tren      = Int(IniRead($ruta, $seccion, "tren",         0))
$spoilers  = Int(IniRead($ruta, $seccion, "spoilers",     0))
$autopilot = Int(IniRead($ruta, $seccion, "autopilot",    0))

Local $urlGeoFS = "https://www.geo-fs.com/geofs.php?aircraft=" & $urlAvion

Local $hwnd = WinActivate("[CLASS:MozillaWindowClass]")
If $hwnd = 0 Then
   Run("C:\Program Files\Mozilla Firefox\firefox.exe " & $urlGeoFS)
   Sleep(10000)
Else
   WinWaitActive("[ACTIVE]", "", 5)
   Sleep(500)
   Send("^l")
   Sleep(600)
   Send($urlGeoFS)
   Sleep(300)
   Send("{ENTER}")
   Sleep(10000)
EndIf

Local $motor = MsgBox(4, "Motor", "El motor ya esta encendido?" & @CRLF & _
   "SI = ya encendido" & @CRLF & _
   "NO = hay que encenderlo")

MsgBox(0, "Preparado", "Aeronave: " & $idAvion & @CRLF & @CRLF & _
   "1. Verifica que GeoFS cargo" & @CRLF & _
   "2. Haz CLIC en el juego" & @CRLF & _
   "3. Da OK y no toques nada")

Sleep(3000)
WinActivate("[CLASS:MozillaWindowClass]")
Sleep(1000)
WinWaitActive("[CLASS:MozillaWindowClass]", "", 5)
Sleep(500)

Local $cx = @DesktopWidth / 2
Local $cy = @DesktopHeight / 2
MouseClick("left", $cx, $cy)
Sleep(1000)

; PREPARAR

If $motor = 7 Then
   Mantener($VK_E, 200)
   Sleep(3000)
EndIf
Send(";")
Sleep(500)

If $flaps_dep > 0 Then
   Local $i
   For $i = 1 To $flaps_dep
      Send("[")
      Sleep(300)
   Next
   Sleep(500)
EndIf

; ACELERAR
Presionar($VK_W)
Sleep($T_accel)

Sleep($T_pista)

; DESPEGAR
Presionar($VK_K)
Sleep($T_rotar)
Soltar($VK_K)
Sleep(500)

If $tren = 1 Then
   Mantener($VK_G, 200)
   Sleep(1000)
EndIf

; SUBIR
Sleep($T_subida)

Soltar($VK_W)
Sleep(500)

Mantener($VK_I, 800)
Sleep(500)

If $flaps_dep > 0 Then
   Local $j
   For $j = 1 To $flaps_dep
      Send("]")
      Sleep(300)
   Next
   Sleep(500)
EndIf

; CRUCERO
If $autopilot = 1 Then
   Mantener($VK_A, 200)
   Sleep(500)
EndIf

Sleep($T_vuelo)

If $autopilot = 1 Then
   Mantener($VK_A, 200)
   Sleep(500)
EndIf

; DESCENSO
Presionar($VK_S)
Sleep($T_accel)
Soltar($VK_S)
Sleep(1000)

If $tren = 1 Then
   Mantener($VK_G, 200)
   Sleep(1000)
EndIf

If $flaps_ate > 0 Then
   Local $k
   For $k = 1 To $flaps_ate
      Send("[")
      Sleep(300)
   Next
   Sleep(500)
EndIf

Mantener($VK_I, 1000)
Sleep($T_bajar)
Sleep($T_final)

; ATERRIZAJE

Presionar($VK_K)
Sleep($T_flare)
Soltar($VK_K)
Sleep(500)

If $spoilers = 1 Then
   Mantener($VK_B, 200)
   Sleep(300)
EndIf

Presionar($VK_Q)
Sleep($T_freno)
Soltar($VK_Q)
Sleep(500)

; APAGAR
Send(";")
Sleep(300)
Mantener($VK_E, 200)

MsgBox(0, "Agente", "Vuelo finalizado: " & $idAvion)
