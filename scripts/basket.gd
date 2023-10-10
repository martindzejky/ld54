extends ItemContainer
class_name Basket


# if not null, this is the customer currently using this basket
var customer: Customer


func _on_picked_up():
    $shadow.visible = false
    $shape.disabled = true

func _on_stored():
    $shadow.visible = false
    #$shape.disabled = true # has to be enabled for cash desk interaction


func _on_dropped():
    $shadow.visible = true
    $shape.disabled = false

func _on_retrieved():
    $shadow.visible = true
    $shape.disabled = false
