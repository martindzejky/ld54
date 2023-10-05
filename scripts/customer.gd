extends Human
class_name Customer


# what products the customer wants
var wantsList: Array[Product] = []
# what products the customer wanted but did not found
var unsatisfiedList: Array[Product] = []

# where the customer wants to go
var targetPosition: Vector2
# what product the customer wants to fetch
var targetProduct: Product
# if not null, customer is using this basket
var myBasket: Basket


func _init():
    call_deferred('setupColor')

func setupColor():

    # randomize the shirt color
    var randomColor := Color.from_hsv(randf(), 0.8, 0.8)

    $sprite.material.set_shader_parameter('modulate', randomColor)
    $"sprite-arms".material.set_shader_parameter('modulate', randomColor)


func _ready():

    $agent.max_speed = walkSpeed

    # choose products that the customer wants

    var catalogProducts = Catalog.get_children()
    assert(catalogProducts.size() > 0, 'The catalog is empty!')

    for i in range(randi_range(1, 4)):
        var product = catalogProducts.pick_random()
        assert(product is Product, 'The catalog contains a node which is not a Product!')
        wantsList.append(product)

func _process(delta):
    super(delta)
    walkAndPush(delta)


func displayCallout(index: int, product: Product = null):

    $"ui-timer".stop()
    $ui.visible = true
    Sfx.play('callout')

    $ui/margin/center/texture.texture.region = Rect2(index * 16, 0, 16, 16)

    if not product:
        $"ui/margin/center/product-texture".visible = false

    else:
        $"ui/margin/center/product-texture".visible = true
        $"ui/margin/center/product-texture".texture = AtlasTexture.new()
        $"ui/margin/center/product-texture".texture.atlas = product.get_node('sprite').texture
        $"ui/margin/center/product-texture".texture.region = Rect2(
            product.get_node('sprite').frame * 16.0,
            0.0,
            16.0,
            16.0
        )

    $"ui-timer".start()

func hideCallout():
    $ui.visible = false


func _on_agent_velocity_computed(safeVelocity):
    velocity = safeVelocity
