extends Node2D
class_name FloatingPrice


func setPrice(price: float):
    $label.text = '+' + var_to_str(price) + '€'

func _process(delta):
    position.y -= delta * 10
