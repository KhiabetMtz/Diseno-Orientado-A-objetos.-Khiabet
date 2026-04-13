; Agente 4 - Redes
; Escanea una red haciendo ping a un rango de IPs
; Muestra ipconfig y guarda resultados en archivo
; F12 para detener

HotKeySet("{F12}", "Detener")
Func Detener()
   MsgBox(0, "Agente", "Se detuvo.")
   Exit
EndFunc

; pedir la red al usuario
Local $red = InputBox("Red", "Escribe los primeros 3 octetos (ej: 192.168.1.):", "192.168.1.")
If @error Then Exit

Local $inicio = InputBox("Rango", "IP inicial (0-255):", "1")
If @error Then Exit

Local $fin = InputBox("Rango", "IP final (0-255):", "20")
If @error Then Exit

Local $tiempo = 300

; abrir cmd y mostrar ipconfig
Run("cmd")
Sleep(3000)
Send("ipconfig" & @CRLF)
Sleep(2000)

; avisar que va a empezar el escaneo
MsgBox(0, "Escaneo", "Se va a escanear de " & $red & $inicio & " a " & $red & $fin & @CRLF & _
   "Los resultados se guardan en resultados_red.txt")

; archivo para guardar resultados
Local $archivo = @ScriptDir & "\resultados_red.txt"
Local $hArchivo = FileOpen($archivo, 2)

FileWriteLine($hArchivo, "=== Escaneo de red ===")
FileWriteLine($hArchivo, "Red: " & $red)
FileWriteLine($hArchivo, "Rango: " & $inicio & " a " & $fin)
FileWriteLine($hArchivo, "Fecha: " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN)
FileWriteLine($hArchivo, "")

; contadores
Local $activos = 0
Local $inactivos = 0

; hacer ping a cada IP del rango
Local $cont
For $cont = Int($inicio) To Int($fin)
   Local $ip_actual = $red & $cont
   Local $respuesta = Ping($ip_actual, $tiempo)

   If $respuesta > 0 Then
      ConsoleWrite($ip_actual & " - ACTIVO (" & $respuesta & " ms)" & @CRLF)
      FileWriteLine($hArchivo, $ip_actual & " - ACTIVO (" & $respuesta & " ms)")
      $activos += 1
   Else
      ConsoleWrite($ip_actual & " - sin respuesta" & @CRLF)
      FileWriteLine($hArchivo, $ip_actual & " - sin respuesta")
      $inactivos += 1
   EndIf
Next

; resumen
FileWriteLine($hArchivo, "")
FileWriteLine($hArchivo, "=== Resumen ===")
FileWriteLine($hArchivo, "Activos: " & $activos)
FileWriteLine($hArchivo, "Inactivos: " & $inactivos)
FileWriteLine($hArchivo, "Total escaneados: " & ($activos + $inactivos))
FileClose($hArchivo)

MsgBox(0, "Resultado", "Escaneo terminado." & @CRLF & _
   "Activos: " & $activos & @CRLF & _
   "Inactivos: " & $inactivos & @CRLF & @CRLF & _
   "Resultados guardados en resultados_red.txt")

; preguntar si quiere ver el archivo
Local $ver = MsgBox(4, "Ver", "Quieres abrir el archivo de resultados?")
If $ver = 6 Then
   Run("notepad.exe " & $archivo)
EndIf
