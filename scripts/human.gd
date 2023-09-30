extends CharacterBody2D
class_name Human


@export var walkSpeed = 30.0



func isCarryingAnything() -> bool:
    return $"sprite-arms".visible

func pickItem(item: Node2D):
    if isCarryingAnything(): return
    $"sprite-arms".visible = true
    
func dropItem():
    if not isCarryingAnything(): return
    $"sprite-arms".visible = false
