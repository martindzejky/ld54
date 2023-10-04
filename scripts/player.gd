extends Human
class_name Player



func _physics_process(_delta):


    # if any GUI is focused, ignore move inputs
    if get_viewport().gui_get_focus_owner():
        $animation.play('thinking')
        return

    var moveX := Input.get_axis("move_left", "move_right")
    var moveY := Input.get_axis("move_up", "move_down")
    var moveInput := Vector2(moveX, moveY).normalized()

    if moveInput.length_squared() > 0:
        $animation.play('walk')
    else:
        $animation.play('idle')

    velocity = moveInput * walkSpeed
    move_and_slide()

func _process(delta):

    super(delta)

    # if any GUI is focused, ignore move inputs
    if get_viewport().gui_get_focus_owner(): return

    if Input.is_action_just_pressed("interact"):
        interact()


func sortingFunction(a, b):

    # always prefer baskets
    if b is Basket: return false
    if a is Basket: return true

    # prefer interacting with containers first
    if b is ItemContainer: return false
    if a is ItemContainer: return true

    # sort by distance
    return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)


func interact():

    var overlappingBodies := $"facing/interaction-area".get_overlapping_bodies() as Array[Node2D]
    var overlappingAreas := $"facing/interaction-area".get_overlapping_areas() as Array[Area2D]

    overlappingBodies.append_array(overlappingAreas)
    overlappingBodies.sort_custom(sortingFunction)

    # interact with the first interactible overlapping body
    for body in overlappingBodies:

        if body.is_in_group('door'):
            (body as Door).toggle()
            return
        if body.is_in_group('door-area'):
            (body.get_parent() as Door).toggle()
            return

        if body is CashDeskComputer:

            if isCarryingAnything():

                var item := dropItem()
                if item is Product and item.customer:
                    item.isScanned = true
                    item.get_node('scanned-check').visible = true
                    body.scanItem()
                pickItem(item)

            else:
                body.openUI()
                body.focusUI()

            return

        if body is ItemContainer:
            var container := body as ItemContainer

            if isCarryingAnything():
                if container.canStoreItem():
                    var item := dropItem()
                    if item:

                        # make sure that if carrying a basket, it cannot be inserted
                        # (unless this is a cash desk)
                        if item is ItemContainer and not container.is_in_group('cash-desk'):
                            pickItem(item)
                            return
                        else:
                            container.storeItem(item)
                            return

            else:
                if container.capacity > 1:
                    container.openUI()
                    container.focusUI()
                    return
                else:
                    var item := container.retrieveItem()
                    if item:
                        pickItem(item)
                        return

        if body.is_in_group('pickable') and not isCarryingAnything():
            pickItem(body)
            return


    # if nothing can be interacted with, the player can drop the item they are carrying
    if isCarryingAnything():
        dropItem()
