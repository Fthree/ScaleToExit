extends Node2D

const Level1 := preload("res://levels/level1.tscn")
const Level2 := preload("res://levels/level2.tscn")
const UI_Level1 := preload("res://UI/Level1.tscn")
const UI_Level2 := preload("res://UI/Level2.tscn")

var levels: Array = [Level1, Level2]
var uis: Array = [UI_Level1, UI_Level2]
var levelCount = 0

var keys_available: Array = []
var keys_found: int = 0
var level: Node
var ui: CanvasLayer

func _ready():

    level = levels[levelCount].instantiate()
    ui = uis[levelCount].instantiate()
    add_child(level)
    add_child(ui)
    keys_available = level.get_node("Elements").get_node("Keys").get_children() as Array
    for key in keys_available:
        key.picked_up.connect(_picked_up_key)

func _picked_up_key():
    keys_found += 1
    if keys_found >= keys_available.size():
        levelCount+=1
        remove_child(level)
        remove_child(ui)
        level = levels[levelCount].instantiate()
        ui = uis[levelCount].instantiate()
        add_child(level)
        add_child(ui)
        keys_found = 0
        