extends Human
class_name Customer


func _init():
    
    # randomize the shirt color
    var randomColor := Color.from_hsv(randf(), 0.8, 0.8)
    
    $sprite.material.set_shader_parameter('modulate', randomColor)
    $"sprite-arms".material.set_shader_parameter('modulate', randomColor)
