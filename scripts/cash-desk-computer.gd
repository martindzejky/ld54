extends StaticBody2D
class_name CashDeskComputer

func focusUI():
    openUI()
    $"ui/panel/margin/vbox/actions/close-ui".call_deferred('grab_focus')

func openUI():
    $ui.visible = true

func closeUI():
    $ui.visible = false

func _process(_delta):
    if Input.is_action_just_pressed('ui_cancel'):
        closeUI()
