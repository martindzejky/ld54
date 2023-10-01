extends Control


func _ready():
    
    Shop.soldToday = 0.0
    Shop.isOpen = true
    
    $margin/center/label.text = 'Day ' + var_to_str(Shop.day)


func _on_timer_timeout():
    get_tree().change_scene_to_file('res://main.tscn')
