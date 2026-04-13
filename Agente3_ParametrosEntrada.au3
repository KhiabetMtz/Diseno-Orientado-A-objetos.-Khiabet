; Agente 3 - Manejo de parametros de entrada
; Recibe datos del usuario por InputBox y MsgBox
; Los guarda en un archivo .ini y los usa despues
; F12 para detener

HotKeySet("{F12}", "Detener")
Func Detener()
   MsgBox(0, "Agente", "Se detuvo.")
   Exit
EndFunc

; pedir datos al usuario
Local $nombre = InputBox("Datos", "Escribe tu nombre:")
If @error Then Exit

Local $edad = InputBox("Datos", "Escribe tu edad:")
If @error Then Exit

Local $materia = InputBox("Datos", "Escribe la materia:")
If @error Then Exit

; preguntar turno con botones
Local $turno_res = MsgBox(3, "Turno", _
   "SI = Matutino" & @CRLF & _
   "NO = Vespertino" & @CRLF & _
   "CANCELAR = Mixto")

Local $turno = ""
If $turno_res = 6 Then
   $turno = "Matutino"
ElseIf $turno_res = 7 Then
   $turno = "Vespertino"
Else
   $turno = "Mixto"
EndIf

; pedir numero de practica
Local $numPractica = InputBox("Datos", "Numero de practica (1-10):", "1")
If @error Then Exit

; validar que sea numero
If Not StringIsDigit($numPractica) Then
   MsgBox(16, "Error", "Eso no es un numero valido.")
   Exit
EndIf

If Int($numPractica) < 1 Or Int($numPractica) > 10 Then
   MsgBox(16, "Error", "El numero debe ser entre 1 y 10.")
   Exit
EndIf

; guardar todo en un .ini
Local $archivoSalida = @ScriptDir & "\datos_entrada.ini"

IniWrite($archivoSalida, "Usuario", "nombre",    $nombre)
IniWrite($archivoSalida, "Usuario", "edad",       $edad)
IniWrite($archivoSalida, "Usuario", "materia",    $materia)
IniWrite($archivoSalida, "Usuario", "turno",      $turno)
IniWrite($archivoSalida, "Usuario", "practica",   $numPractica)
IniWrite($archivoSalida, "Usuario", "fecha",      @YEAR & "/" & @MON & "/" & @MDAY)
IniWrite($archivoSalida, "Usuario", "hora",       @HOUR & ":" & @MIN & ":" & @SEC)

; mostrar resumen
Local $resumen = "=== Datos capturados ===" & @CRLF & @CRLF
$resumen &= "Nombre: " & $nombre & @CRLF
$resumen &= "Edad: " & $edad & @CRLF
$resumen &= "Materia: " & $materia & @CRLF
$resumen &= "Turno: " & $turno & @CRLF
$resumen &= "Practica: " & $numPractica & @CRLF
$resumen &= "Fecha: " & @YEAR & "/" & @MON & "/" & @MDAY & @CRLF
$resumen &= "Hora: " & @HOUR & ":" & @MIN

MsgBox(0, "Resumen", $resumen)

; preguntar si quiere abrir el archivo
Local $abrir = MsgBox(4, "Abrir", "Quieres abrir el archivo datos_entrada.ini?")
If $abrir = 6 Then
   Run("notepad.exe " & $archivoSalida)
EndIf

MsgBox(0, "Agente", "Parametros guardados correctamente.")
