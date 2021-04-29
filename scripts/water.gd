extends Node2D


export(int) var minWater
export(int) var maxWater

var waterAmount


func _ready():
    waterAmount = rand_range(minWater, maxWater)


func _on_collider_area_entered(area):
    # area is the collider on a root, get the parent
    var root = area.get_parent() as Branch

    if not root is Branch:
        return

    if not root.canCollectWater:
        return

    # after the water is collected, destroy it
    destroySelf()


func destroySelf():
    queue_free()

    # TODO: particles and such
