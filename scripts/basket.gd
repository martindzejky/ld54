extends ItemContainer
class_name Basket

func _on_picked_up():
    $shadow.visible = false
    $shape.disabled = true
    $obstacle.avoidance_enabled = false
    
func _on_stored():
    $shadow.visible = false
    $shape.disabled = true
    $obstacle.avoidance_enabled = false
    

func _on_dropped():
    $shadow.visible = true
    $shape.disabled = false
    $obstacle.avoidance_enabled = true

func _on_retrieved():
    $shadow.visible = true
    $shape.disabled = false
    $obstacle.avoidance_enabled = true
