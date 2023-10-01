extends StaticBody2D
class_name CashDeskComputer

func focusUI():
    openUI()
    $"ui/panel/margin/vbox/actions/close-ui".call_deferred('grab_focus')

func openUI():
    $ui.visible = true
    Sfx.play('ui-open')

func closeUI():
    $ui.visible = false
    Sfx.play('ui-close')

func _process(_delta):
    if Input.is_action_just_pressed('ui_cancel'):
        closeUI()

func scanItem():
    Sfx.play('scan')
    $scan.visible = true
    await get_tree().create_timer(0.05).timeout
    $scan.visible = false
