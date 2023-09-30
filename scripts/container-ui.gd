extends Control


@export_node_path() var containerNode: NodePath


func _on_button_pick_pressed():
    var player := get_tree().get_first_node_in_group('player') as Player
    
    if not player: return
    if player.isCarryingAnything(): return
    
    assert(containerNode, 'Missing container node!')
    
    var node := get_node(containerNode)
    
    player.pickItem(node)
    node.closeUI()
