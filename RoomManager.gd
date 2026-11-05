extends Node
class_name RoomManager

enum RoomType { TUTORIAL, STANDARD, BOSS, DOUBLE_BOSS, CONVEYOR }

signal room_entered(room_number: int, room_type: RoomType)

@export var room_container: Node
@export var tutorial_scene: PackedScene
@export var standard_scene: PackedScene
@export var boss_scene: PackedScene
@export var double_boss_scene: PackedScene
@export var conveyor_scene: PackedScene

@export var boss_rooms: Array[int] = [3, 6]
@export var conveyor_rooms: Array[int] = []
@export var double_boss_from: int = 9

var current_room: int = 0
var player_score: int = 0


func enter_next_room() -> void:
	enter_room(current_room + 1)


func enter_room(room_number: int) -> void:
	if room_number < 1:
		push_error("El número de habitación debe ser mayor que cero.")
		return
	if room_container == null:
		push_error("Asigna RoomContainer en el Inspector.")
		return

	var room_type := _get_room_type(room_number)
	var scene := _get_scene(room_type)
	if scene == null:
		push_error("No hay una escena asignada para el tipo de habitación: %s" % room_type)
		return

	for child in room_container.get_children():
		room_container.remove_child(child)
		child.queue_free()

	room_container.add_child(scene.instantiate())
	current_room = room_number
	room_entered.emit(current_room, room_type)


func _get_room_type(room_number: int) -> RoomType:
	if room_number == 1:
		return RoomType.TUTORIAL
	if room_number >= double_boss_from:
		return RoomType.DOUBLE_BOSS
	if room_number in conveyor_rooms:
		return RoomType.CONVEYOR
	if room_number in boss_rooms:
		return RoomType.BOSS
	return RoomType.STANDARD


func _get_scene(room_type: RoomType) -> PackedScene:
	match room_type:
		RoomType.TUTORIAL:
			return tutorial_scene
		RoomType.STANDARD:
			return standard_scene
		RoomType.BOSS:
			return boss_scene
		RoomType.DOUBLE_BOSS:
			return double_boss_scene
		RoomType.CONVEYOR:
			return conveyor_scene
	return null
