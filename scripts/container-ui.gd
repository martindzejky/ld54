extends Control


@export_node_path() var rootNode: NodePath
@export_node_path() var containerNode: NodePath
@export_node_path() var gridNode: NodePath


func _ready():
    
    assert(rootNode, 'Missing root node!')
    assert(gridNode, 'Missing grid node!')
    
    var root := get_node(rootNode)
    var grid := get_node(gridNode)
    
    grid.columns = maxf(2, floorf(sqrt(root.capacity)))

func _process(_delta):
    
    if not Input.is_action_just_pressed('ui_cancel'): return
    
    assert(rootNode, 'Missing root node!')
    
    var node := get_node(rootNode)
    node.closeUI()


func updateGridUI():
    
    # update the buttons in the grid UI based on what items are in the container
    
    assert(containerNode, 'Missing container node!')
    assert(gridNode, 'Missing grid node!')
    
    var container := get_node(containerNode)
    var grid := get_node(gridNode)
    
    # drop old buttons
    for btn in grid.get_children():
        grid.remove_child(btn)
    
    # add button for each item in container
    for item in container.get_children():
        
        var btn := Button.new()
        
        btn.icon = AtlasTexture.new()
        btn.icon.atlas = item.get_node('sprite').texture
        btn.icon.region = Rect2(
            item.get_node('sprite').frame * 16.0,
            0.0,
            16.0,
            16.0
        )
        
        grid.add_child(btn)
        
        btn.connect('pressed', func(): _on_grid_button_pressed(btn))


func _on_button_pick_pressed():
    var player := get_tree().get_first_node_in_group('player') as Player
    
    if not player: return
    if player.isCarryingAnything(): return
    
    assert(rootNode, 'Missing root node!')
    
    var node := get_node(rootNode)
    
    player.pickItem(node)
    node.closeUI()


func _on_container_child_entered_tree(_node):
    updateGridUI()


func _on_container_child_exiting_tree(_node):
    updateGridUI()


func _on_container_child_order_changed():
    updateGridUI()

func _on_grid_button_pressed(button: Button):
    
    var player := get_tree().get_first_node_in_group('player') as Player
    
    if not player: return
    if player.isCarryingAnything(): return
    
    if not button.is_inside_tree() or not is_instance_valid(button): return
    
    var index := button.get_index()
    
    assert(rootNode, 'Missing root node!')
    
    var node := get_node(rootNode) as ItemContainer
    
    var item := node.retrieveItem(index)
    if not item: return
    
    player.pickItem(item)
    node.closeUI()
