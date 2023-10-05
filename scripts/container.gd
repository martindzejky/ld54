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

    if item.has_method('_on_stored'):
        item.call('_on_stored')

func retrieveItem(index = 0) -> Node2D:
    if index < 0: return null
    if index >= $container.get_child_count(): return null

    var item := $container.get_child(index)
    if not item: return null

    var level := get_tree().get_first_node_in_group('level')
    if not level: return null

    if item.has_method('_on_retrieved'):
        item.call('_on_retrieved')

    item.reparent(level)
    return item

func focusUI():
    openUI()
    $"container-ui/panel/margin/vbox/actions/button-close".call_deferred('grab_focus')

func openUI():
    $"container-ui".visible = true
    Sfx.play('ui-open')

func closeUI():
    $"container-ui".visible = false
    Sfx.play('ui-close')
