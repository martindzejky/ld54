extends StaticBody2D
class_name Product


@export var type: String
@export var price: float = 0.0

# who wants to purchase this product
var customer: Customer
var isScanned := false


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
