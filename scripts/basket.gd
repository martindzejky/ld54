extends ItemContainer
class_name Basket


# if not null, this is the customer currently using this basket
var customer: Customer


func _on_picked_up():
    $shadow.visible = false
    $shape.disabled = true
    $obstacle.avoidance_enabled = false
    get_tree().call_deferred('call_group', 'navigation', 'update')

func _on_stored():
    $shadow.visible = false
    #$shape.disabled = true # has to be enabled for cash desk interaction
    $obstacle.avoidance_enabled = false


func _on_dropped():
    $shadow.visible = true
    $shape.disabled = false
    $obstacle.avoidance_enabled = true
    get_tree().call_deferred('call_group', 'navigation', 'update')

func _on_retrieved():
    $shadow.visible = true
    $shape.disabled = false
    $obstacle.avoidance_enabled = true
