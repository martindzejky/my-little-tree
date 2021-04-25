extends TileMap

export(Resource) var treeData

export(Array, int) var tileOptionChances
export(Array, String) var tileOptionNames

var tileOptionsSumChance = 0

var generationStart: Vector2
var generationEnd: Vector2

func _ready():
    generationStart = Vector2(-treeData.groundWidth / 32, 0)
    generationEnd = Vector2(treeData.groundWidth / 32, treeData.groundHeight / 8)

    assert(tileOptionChances.size() == tileOptionNames.size(), 'tile option size do not match')

    for option in tileOptionChances:
        tileOptionsSumChance += option

    assert(tileOptionsSumChance > 0, 'tile options sum chance is not more than 0, selection logic math will not work')

    # generate tiles
    for x in range(generationStart.x, generationEnd.x):
        for y in range(generationStart.y, generationEnd.y):
            generateTile(x, y)

func generateTile(x: int, y: int):
    # select a random tile
    var s = rand_range(0, tileOptionsSumChance)
    var i = 0
    var selected

    while s > 0:
        selected = tileOptionNames[i]
        s -= tileOptionChances[i]
        i += 1

    if not selected:
        return

    var tile = tile_set.find_tile_by_name(selected)
    set_cell(x, y, tile)
