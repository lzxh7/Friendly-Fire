class_name EnemySpawn
extends Resource

@export var scene: PackedScene
@export var min_pack := 1
@export var max_pack := 1
# This enemy must appear during this wave, and can appear in any following one
@export var wave := 1
