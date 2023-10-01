extends ItemContainer


func _ready():
    super()
    
    # spawn random items to sell
    
    for i in range(randi_range(2, 8)):
        
        var product := Catalog.get_children().pick_random() as Product
        var created := product.duplicate()
        
        # add to the storage
        get_tree().get_first_node_in_group('level').add_child(created)
        storeItem(created)
