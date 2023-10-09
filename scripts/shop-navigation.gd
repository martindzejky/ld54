extends Node2D
class_name ShopNavigation


@export_node_path("TileMap") var tileMapPath: NodePath
@onready var tileMap := get_node(tileMapPath) as TileMap
@onready var tileSize := tileMap.tile_set.tile_size


func _ready():
    assert(tileMap is TileMap, 'Missing tile map!')
    update()


func update() -> void:

    # TODO: run in separate thread

    # clear existing navigation nodes
    for child in get_children():
        remove_child(child)
        child.free()

    # get all baskets in the level
    var baskets := get_tree().get_nodes_in_group('basket').filter(hasShapeEnabled)

    # TODO: testing
    #baskets = []

    # iterate over all tiles and grab navigation data
    for cell in tileMap.get_used_cells(0):

        var tile := tileMap.get_cell_tile_data(0, cell)
        var navigationPolygon := tile.get_navigation_polygon(0) as NavigationPolygon
        if not navigationPolygon: continue

        var cellPosition := cell * tileSize + tileSize / 2
        var cellTransform := Transform2D(0, cellPosition)
        var cellUntransform := Transform2D(0, -cellPosition)

        navigationPolygon = navigationPolygon.duplicate()

        # clip obstacles
        for basket in baskets:
            var navigationVertices := navigationPolygon.get_vertices()
            var basketVertices := getObstaclePolygon(basket)

            navigationVertices = cellTransform * navigationVertices
            basketVertices = Transform2D(basket.global_transform) * basketVertices

            var clipped: Array[PackedVector2Array] = []

            for i in range(navigationPolygon.get_polygon_count()):
                var polygonIndices := navigationPolygon.get_polygon(i)
                var polygon := PackedVector2Array()
                for index in polygonIndices:
                    polygon.append(navigationVertices[index])

                var clippedPolygon := Geometry2D.clip_polygons(polygon, basketVertices)
                clipped.append_array(clippedPolygon)

            # safety...
            #clipped = clipped.filter(func (polygon): return polygon.size() >= 3)

            navigationPolygon.clear_polygons()
            navigationPolygon.clear_outlines()

            # flatten clipped polygons for vertices
            var flat := PackedVector2Array()
            for polygon in clipped:
                for point in polygon:
                    var localPoint := cellUntransform * point
                    flat.append(localPoint)

            navigationPolygon.set_vertices(flat)

            # add polygon indices
            var currentIndex := 0
            for polygon in clipped:
                var indices := PackedInt32Array()
                for i in range(polygon.size()):
                    indices.append(currentIndex + i)
                navigationPolygon.add_polygon(indices)
                currentIndex += polygon.size()

        # create navigation region node with the navigation polygon
        var navigationRegion = NavigationRegion2D.new()
        navigationRegion.navigation_layers = 2
        navigationRegion.use_edge_connections = true
        navigationRegion.set_navigation_polygon(navigationPolygon)
        navigationRegion.set_position(cellPosition)
        add_child(navigationRegion)


func hasShapeEnabled(node: Node) -> bool:
    var shape := node.get_node('shape') as CollisionShape2D
    if not shape: return false
    return not shape.disabled

func getObstaclePolygon(node: Node) -> PackedVector2Array:
    var obstacle := node.get_node('obstacle') as Polygon2D
    assert(obstacle, 'Missing obstacle node!')

    var polygon := obstacle.polygon
    assert(polygon and polygon.size() >= 3, 'Obstacle polygon must have at least 3 points!')

    return polygon
