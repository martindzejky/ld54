extends Area2D


func _on_body_entered(body: Node2D):
    if body.is_in_group('player'):
        
        # ignore if the container is being carried
        var parent := get_parent()
        var containerParent := parent.get_parent()
        
        if containerParent and containerParent.name == 'hands': return
        if containerParent and containerParent.name == 'container': return
        
        parent.openUI()


func _on_body_exited(body: Node2D):
    if body.is_in_group('player'):
        get_parent().closeUI()
