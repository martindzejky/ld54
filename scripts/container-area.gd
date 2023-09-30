extends Area2D


func _on_body_entered(body: Node2D):
    if body.is_in_group('player'):
        get_parent().openUI()


func _on_body_exited(body: Node2D):
    if body.is_in_group('player'):
        get_parent().closeUI()
