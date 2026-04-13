; Agente 5 - Sistemas operativos
; Genera respaldos automaticos de carpetas
; F12 para detener

HotKeySet("{F12}", "Detener")
Func Detener()
   MsgBox(0, "Agente", "Se detuvo.")
   Exit
EndFunc

; mostrar info del sistema
Local $info = "=== Info del sistema ===" & @CRLF & @CRLF
$info &= "SO: " & @OSVersion & @CRLF
$info &= "Arquitectura: " & @OSArch & @CRLF
$info &= "Nombre PC: " & @ComputerName & @CRLF
$info &= "Usuario: " & @UserName & @CRLF
$info &= "Directorio Windows: " & @WindowsDir & @CRLF
$info &= "Espacio en C: " & Round(DriveSpaceFree("C:\") / 1024, 2) & " GB libres" & @CRLF
$info &= "Hora actual: " & @HOUR & ":" & @MIN & ":" & @SEC

MsgBox(0, "Sistema", $info)

; preguntar donde hacer el respaldo
Local $modo = MsgBox(3, "Modo", _
   "SI = Respaldo inmediato" & @CRLF & _
   "NO = Esperar al minuto :00" & @CRLF & _
   "CANCELAR = Salir")

If $modo = 2 Then Exit

; crear estructura de carpetas si no existe
Local $base = @ScriptDir & "\respaldos"
If Not FileExists($base) Then DirCreate($base)

; carpetas a respaldar
Local $carpetas[4] = ["a", "b", "c", "d"]
Local $i

; crear las carpetas de ejemplo si no existen
For $i = 0 To 3
   Local $ruta_carpeta = "C:\" & $carpetas[$i]
   If Not FileExists($ruta_carpeta) Then DirCreate($ruta_carpeta)
Next

; crear carpeta de respaldos dentro de d
Local $ruta_resp = "C:\a\b\c\d\respaldos"
DirCreate("C:\a\b")
DirCreate("C:\a\b\c")
DirCreate("C:\a\b\c\d")
DirCreate($ruta_resp)

If $modo = 7 Then
   ; esperar al minuto :00
   MsgBox(0, "Esperando", "El agente va a esperar hasta el minuto :00" & @CRLF & _
      "Hora actual: " & @HOUR & ":" & @MIN)

   Local $ejecutar = True
   While $ejecutar
      Sleep(1000)
      If @MIN = "00" Then
         $ejecutar = False
      EndIf
   WEnd
EndIf

; ejecutar el respaldo
Run("cmd")
Sleep(3000)

; ir a cada carpeta y hacer DIR > archivo.txt
Send("C:" & @CRLF)
Sleep(500)
Send("cd \a" & @CRLF)
Sleep(500)
Send("DIR > A.txt" & @CRLF)
Sleep(500)
Send("COPY A.txt .\b\c\d\respaldos" & @CRLF)
Sleep(1000)

Send("cd .\b" & @CRLF)
Sleep(500)
Send("DIR > B.txt" & @CRLF)
Sleep(500)
Send("COPY B.txt .\c\d\respaldos" & @CRLF)
Sleep(1000)

Send("cd .\c" & @CRLF)
Sleep(500)
Send("DIR > C.txt" & @CRLF)
Sleep(500)
Send("COPY C.txt .\d\respaldos" & @CRLF)
Sleep(1000)

Send("cd .\d" & @CRLF)
Sleep(500)
Send("DIR > D.txt" & @CRLF)
Sleep(500)
Send("COPY D.txt .\respaldos" & @CRLF)
Sleep(1000)

Send("cd .\respaldos" & @CRLF)
Sleep(500)
Send("DIR" & @CRLF)
Sleep(1000)

MsgBox(0, "Agente", "Respaldo completado." & @CRLF & _
   "Archivos guardados en C:\a\b\c\d\respaldos\")
