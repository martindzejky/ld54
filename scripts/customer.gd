extends Human
class_name Customer


# where the customer wants to go
var targetPosition: Vector2
# if not null, customer is using this basket
var myBasket: Basket


func _init():
    call_deferred('setupColor')

func setupColor():
    
    # randomize the shirt color
    var randomColor := Color.from_hsv(randf(), 0.8, 0.8)
    
    $sprite.material.set_shader_parameter('modulate', randomColor)
    $"sprite-arms".material.set_shader_parameter('modulate', randomColor)


func _process(_delta):
    
    if OS.is_debug_build():
        queue_redraw()

func _draw():
    
    if not OS.is_debug_build(): return
    
    if targetPosition:
        draw_line(Vector2.ZERO, targetPosition - global_position, Color.GREEN)
    
    if myBasket:
        draw_line(Vector2.ZERO, myBasket.global_position - global_position, Color.BLUE)
