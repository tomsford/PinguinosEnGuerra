extends Node

var current_scene = null
var LAN= false

var listo1 = false
var listo2 =false 
var partida_ready=false

var pinguino = 0
# 1 = Amarillo
# 2 = Rosa
# 3 = Verde
# 4 = Gris

var arma = 1
# 1 = Escopeta
# 2 = Bazuca
# 3 = Molotov
# 4 = Bomba

var explosion = 30
# Escopeta = 40
# Bazuca = 80

var regalo = 0
# 1 = Amarillo
# 2 = Azul
# 3 = Naranja
# 4 = Rojo
# 5 = Rosa
# 6 = Verde
# 7 = VerdeAgua
# 8 = Violeta
# 9 = Gris 

var disparo = 1
# 1 = derecha
# 2 = izquierda 

var vida = 200 # es para probar despues se pone en 200
var speed = 0
var salto = 0
var balas = 0
var tiros = 0
var potenciador = 0

var tocoRegalo = false
var actualizadoHUD = true
var tocoArma = false
var tocoArmaPrimeraVez = false

var tiempo = 20 
const tiempoPorNivel = 30# es para probar despues se pone en 60 o mas
var puntos = 0 # es para probar despues se pone en 0
var disparo_SP = false
var velocidad = 50
var nivel = 1
const NIVEL_MAXIMO = 6

var apuntando = false

var reproducir = 0
var reproducirV = 0

var balaActiva = false

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	# Eliminar la escena en esta funcion puede causar problemas, 
	# por eso llamamos a otra funcion para asegurarnos que 
	# ya se ejecuto todo el codigo
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)

	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func accionRegalo():
	tocoRegalo = true

func update_time():
	get_tree().get_nodes_in_group("tiempo")[0].text = String(tiempo)
	
func update_puntos():
	get_tree().get_nodes_in_group("puntos")[0].text =  String(puntos)

func update_vida():
	get_tree().get_nodes_in_group("vida")[0].text = String(vida)

