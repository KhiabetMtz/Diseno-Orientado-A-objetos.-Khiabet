; Agente 6 - Manejo de entradas
; Demuestra control de mouse, teclado y hotkeys
; F12 para detener

HotKeySet("{F12}", "Detener")
HotKeySet("{F9}", "EjecutarClics")
HotKeySet("{F10}", "EjecutarTeclado")
HotKeySet("{F11}", "BloquearPC")

Global $corriendo = True

Func Detener()
   $corriendo = False
   MsgBox(0, "Agente", "Se detuvo.")
   Exit
EndFunc

Func EjecutarClics()
   ; hacer clics automaticos
   Local $cantidad = InputBox("Clics", "Cuantos clics quieres? (1-20):", "5")
   If @error Then Return

   If Not StringIsDigit($cantidad) Then
      MsgBox(16, "Error", "Pon un numero valido.")
      Return
   EndIf

   Local $pausa = InputBox("Velocidad", "Pausa entre clics en ms (100-2000):", "500")
   If @error Then Return

   MsgBox(0, "Aviso", "En 3 segundos empiezan los clics." & @CRLF & _
      "Pon el mouse donde quieras hacer clic.")
   Sleep(3000)

   Local $c
   For $c = 1 To Int($cantidad)
      MouseClick("left")
      Sleep(Int($pausa))
   Next

   MsgBox(0, "Listo", "Se hicieron " & $cantidad & " clics.")
EndFunc

Func EjecutarTeclado()
   ; escribir texto automatico
   Local $texto = InputBox("Texto", "Que texto quieres que escriba?:", "Hola mundo")
   If @error Then Return

   Local $veces = InputBox("Repetir", "Cuantas veces? (1-10):", "3")
   If @error Then Return

   MsgBox(0, "Aviso", "En 3 segundos empieza a escribir." & @CRLF & _
      "Abre el Bloc de Notas o donde quieras que escriba.")
   Sleep(3000)

   Local $v
   For $v = 1 To Int($veces)
      Send($texto)
      Send("{ENTER}")
      Sleep(300)
   Next

   MsgBox(0, "Listo", "Se escribio '" & $texto & "' " & $veces & " veces.")
EndFunc

Func BloquearPC()
   ; bloquear la computadora
   Local $confirmar = MsgBox(4, "Bloquear", "Seguro que quieres bloquear la PC?")
   If $confirmar = 6 Then
      Send("#l")
   EndIf
EndFunc

; menu principal
MsgBox(0, "Agente de Entradas", _
   "Teclas disponibles:" & @CRLF & @CRLF & _
   "F9  = Hacer clics automaticos" & @CRLF & _
   "F10 = Escribir texto automatico" & @CRLF & _
   "F11 = Bloquear la PC" & @CRLF & _
   "F12 = Detener el agente" & @CRLF & @CRLF & _
   "El agente queda en espera...")

; loop principal - espera a que presionen una tecla
While $corriendo
   Sleep(100)
WEnd
