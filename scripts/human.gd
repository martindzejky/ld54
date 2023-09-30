extends CharacterBody2D
class_name Human


@export var walkSpeed = 30.0



func isCarryingAnything() -> bool:
    return $"sprite-arms".visible

func pickItem(item: Node2D):
    if isCarryingAnything(): return
    $"sprite-arms".visible = true
    
    item.reparent($hands, false)
    item.position = Vector2.ZERO
    item.rotation = 0
    
    var shadow := item.find_child('shadow')
    if shadow: shadow.visible = false
    
func dropItem() -> Node2D:
    if not isCarryingAnything(): return null
    $"sprite-arms".visible = false
    
    for carriedItem in $hands.get_children():
        var level := get_tree().get_first_node_in_group('level')
        if level:
            carriedItem.reparent(level)
            carriedItem.global_position = global_position
            
            var shadow := carriedItem.find_child('shadow')
            if shadow: shadow.visible = true
            
            return carriedItem
    
    return null
