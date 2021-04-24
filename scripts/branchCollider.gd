extends Area2D

export(NodePath) var spriteToModulatePath

# keep updating the size of the collider's shape based on the size
# of the branch
func _process(delta):
    var root = get_parent()
    assert(root is Branch, "branch sprite does not have branch as parent")

    $shape.position.y = root.length / 2 * root.growDirection

    var shape = $shape.get_shape()
    if not shape:
        shape = RectangleShape2D.new()
        $shape.set_shape(shape)

    shape.extents = Vector2(root.thickness / 2, root.length / 2)



func _on_collider_mouse_entered():
    var sprite = get_node(spriteToModulatePath) as Sprite
    assert(sprite is Sprite)
    sprite.modulate = Color.red


func _on_collider_mouse_exited():
    var sprite = get_node(spriteToModulatePath) as Sprite
    assert(sprite is Sprite)
    sprite.modulate = Color.white
