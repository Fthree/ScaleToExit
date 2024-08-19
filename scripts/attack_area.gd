extends Area2D

signal player_attack

func _ready():
    connect("body_entered", _on_body_entered.bind(self))

func _on_body_entered(body):
    player_attack.emit(body)