extends Node2D

export(Resource) var treeData

# water object to spawn
export(PackedScene) var waterObject

# chance to spawn water for each tile
export(float) var spawnChance

var generationStart: Vector2
var generationEnd: Vector2

func _ready():
    generationStart = Vector2(-treeData.groundWidth / 16, 1)
    generationEnd = Vector2(treeData.groundWidth / 16, treeData.groundHeight / 8)

    # generate tiles
    for x in range(generationStart.x, generationEnd.x):
        for y in range(generationStart.y, generationEnd.y):
            generateTile(x, y)


func generateTile(x: int, y: int):
    if randf() > spawnChance:
        return

    var newWater = waterObject.instance() as Node2D
    newWater.position = Vector2(x * 8 + 4, y * 8 + 4)
    add_child(newWater)
