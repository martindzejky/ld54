extends StaticBody2D
class_name Door


func toggle() -> void:
    
    Sfx.play('door')
    
    if $shape.disabled:
        $shape.disabled = false
        $sprite.frame = 0
        $navigation.enabled = false
    else:
        $shape.disabled = true
        $sprite.frame = 1
        $navigation.enabled = true
