extends PhysicsBody2D
class_name ItemContainer


# if 1, this is a container which can hold a single item on top
@export_range(1, 16) var capacity: int = 1


func _ready():
    assert(has_node('container'), 'ItemContainer missing a container child node!')
    
    if capacity > 1:
        assert(has_node('container-ui'), 'ItemContainer with capacity > 1 must have a UI!')


func hasAnyItems() -> bool:
    return $container.get_child_count() > 0

func canStoreItem() -> bool:
    return $container.get_child_count() < capacity

func storeItem(item: Node2D):
    if not canStoreItem(): return
    
    item.reparent($container, false)
    item.rotation = 0
    
    if capacity == 1:
        item.position = Vector2.ZERO
    else:
        item.position = Vector2(randf_range(-3, 3), randf_range(-1, 1))
    
    var shadow := item.find_child('shadow')
    if shadow: shadow.visible = false

func retrieveItem(index = 0) -> Node2D:
    var item := $container.get_child(index)
    if not item: return null
    
    var level := get_tree().get_first_node_in_group('level')
    if not level: return null
    
    var shadow := item.find_child('shadow')
    if shadow: shadow.visible = true
    
    item.reparent(level)
    return item
    
func focusUI():
    openUI()
    $"container-ui/panel/margin/vbox/actions/button-pick".call_deferred('grab_focus')

func openUI():
    $"container-ui".visible = true

func closeUI():
    $"container-ui".visible = false
