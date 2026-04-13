; Agente 1 - Lectura de parametros
; Lee datos de un archivo .ini y los muestra
; F12 para detener

HotKeySet("{F12}", "Detener")
Func Detener()
   MsgBox(0, "Agente", "Se detuvo.")
   Exit
EndFunc

Local $ruta = @ScriptDir & "\config.ini"

; revisar que exista
If Not FileExists($ruta) Then
   MsgBox(16, "Error", "No encontre config.ini en:" & @CRLF & $ruta)
   Exit
EndIf

; leer todas las secciones del archivo
Local $secciones = IniReadSectionNames($ruta)

If @error Then
   MsgBox(16, "Error", "El archivo .ini esta vacio o mal formado.")
   Exit
EndIf

; mostrar cuantas secciones hay
MsgBox(0, "Info", "Se encontraron " & $secciones[0] & " secciones en config.ini")

; recorrer cada seccion y leer sus claves
Local $i, $j
For $i = 1 To $secciones[0]
   Local $datos = IniReadSection($ruta, $secciones[$i])

   If @error Then
      MsgBox(48, "Aviso", "No se pudo leer la seccion: " & $secciones[$i])
   Else
      Local $texto = "=== " & $secciones[$i] & " ===" & @CRLF & @CRLF
      For $j = 1 To $datos[0][0]
         $texto &= $datos[$j][0] & " = " & $datos[$j][1] & @CRLF
      Next
      MsgBox(0, "Seccion: " & $secciones[$i], $texto)
   EndIf
Next

; leer un valor especifico
Local $avion = InputBox("Buscar", "Escribe el nombre de la seccion (ej: Boeing737):")
If $avion <> "" Then
   Local $T_pista = IniRead($ruta, $avion, "T_pista", "NO ENCONTRADO")
   Local $T_vuelo = IniRead($ruta, $avion, "T_vuelo", "NO ENCONTRADO")
   MsgBox(0, "Resultado", "Para " & $avion & ":" & @CRLF & _
      "T_pista = " & $T_pista & @CRLF & _
      "T_vuelo = " & $T_vuelo)
EndIf

MsgBox(0, "Agente", "Lectura terminada.")
