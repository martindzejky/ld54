extends Control


func _ready():

    Shop.soldToday = 0.0
    Shop.isOpen = true
    Sfx.play('day')

    $margin/center/label.text = 'Day ' + var_to_str(Shop.day)

    await get_tree().process_frame

    $margin/center/label.pivot_offset = $margin/center/label.size / 2
    $margin/center/label.scale = Vector2(6, 6)


func _on_timer_timeout():
    get_tree().change_scene_to_file('res://shop.tscn')
