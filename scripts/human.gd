extends CharacterBody2D
class_name Human


@export var walkSpeed = 30.0

var previousPosition = position


func _process(_delta):

    if previousPosition.distance_squared_to(position) < .1: return

    var facingDirection = previousPosition.direction_to(position)
    $facing.position = facingDirection * 8.0
    $"facing-ray".target_position = $facing.position

    previousPosition = position



func isCarryingAnything() -> bool:
    return $"sprite-arms".visible

func pickItem(item: Node2D, force = false):
    if isCarryingAnything() and not force: return
    $"sprite-arms".visible = true
    Sfx.play('pick')

    item.reparent($hands, false)
    item.position = Vector2.ZERO
    item.rotation = 0

    if item.has_method('_on_picked_up'):
        item.call('_on_picked_up')

func dropItem() -> Node2D:
    if not isCarryingAnything(): return null
    $"sprite-arms".visible = false
    Sfx.play('drop')

    for carriedItem in $hands.get_children():
        var level := get_tree().get_first_node_in_group('level')
        if level:
            carriedItem.reparent(level)

            if $"facing-ray".is_colliding():
                carriedItem.global_position = $"facing-ray".get_collision_point() + $facing.global_position.direction_to(global_position) * 4
            else:
                carriedItem.global_position = $facing.global_position


            if carriedItem.has_method('_on_dropped'):
                carriedItem.call('_on_dropped')

            return carriedItem

    return null


func walkAndPush(delta: float) -> void:

    # try to move in direction of velocity, push objects away,
    # and slide on walls up to 5 times

    for i in range(5):

        var hit := move_and_collide(velocity * delta)
        if not hit: return

        var other := hit.get_collider()
        velocity = velocity.slide(hit.get_normal())

        if other is CharacterBody2D:
            other.move_and_collide(hit.get_remainder().length() * -hit.get_normal() * 0.4)


