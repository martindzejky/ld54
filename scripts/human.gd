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
    
    if item.has_method('_on_picked_up'):
        item.call('_on_picked_up')
    
func dropItem() -> Node2D:
    if not isCarryingAnything(): return null
    $"sprite-arms".visible = false
    
    for carriedItem in $hands.get_children():
        var level := get_tree().get_first_node_in_group('level')
        if level:
            carriedItem.reparent(level)
            carriedItem.global_position = global_position
            
            if carriedItem.has_method('_on_dropped'):
                carriedItem.call('_on_dropped')
            
            return carriedItem
    
    return null
