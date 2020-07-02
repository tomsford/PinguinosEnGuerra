extends Control

var monedasParaCambiar = 0

func _ready():
	if !ScriptGlobal.mutePrincipal:
		$MusicaFondo.play(ScriptGlobal.reproducir)

func _physics_process(delta):
	$CambioMonedas.text = str(monedasParaCambiar)
	$CantidadVida.text = str(ScriptGlobal.vida)
	$CantidadMonedas.text = str(ScriptGlobal.puntos)
	
func _on_mas_pressed():
	if monedasParaCambiar < ScriptGlobal.puntos:
		monedasParaCambiar += 1

func _on_menos_pressed():
	if monedasParaCambiar > 0:
		monedasParaCambiar -= 1

func _on_Cambiar_pressed():
	if monedasParaCambiar > 0:
		ScriptGlobal.vida += monedasParaCambiar * 10
		ScriptGlobal.puntos -= monedasParaCambiar
		monedasParaCambiar = 0

func _on_Seguir_pressed():
	if !ScriptGlobal.mutePrincipal:
		ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene("res://Escenas/publicidad.tscn")
