extends TileMap

export(Resource) var tileOptions

var tileOptionsSumChance = 0

export(Vector2) var generationStart
export(Vector2) var generationEnd

func _ready():
    for option in tileOptions.chances:
        tileOptionsSumChance += option.chance

    assert(tileOptionsSumChance > 0, 'tile options sum chance is not more than 0, selection logic math will not work')

    # generate tiles
    for x in range(generationStart.x, generationEnd.x + 1):
        for y in range(generationStart.y, generationEnd.y + 1):
            generateTile(x, y)

func generateTile(x: int, y: int):
    # select a random tile
    var s = rand_range(0, tileOptionsSumChance)
    var i = 0
    var selected

    while s > 0:
        selected = tileOptions.chances[i].name
        s -= tileOptions.chances[i].chance
        i += 1

    if not selected:
        return

    var tile = tile_set.find_tile_by_name(selected)
    set_cell(x, y, tile)
