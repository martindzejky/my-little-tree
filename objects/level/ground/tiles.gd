extends TileMap

export(Resource) var treeData

export(int) var emptyChance
export(int) var defaultChance

# this would have been much easier if a custom resource could be exported...
export(Array, String) var overridesNames
export(Array, int) var overridesChances

var tileOptionsSumChance = 0

export(Vector2) var generationStart: Vector2
export(Vector2) var generationEnd: Vector2

func _ready():
    if treeData:
        generationStart = Vector2(-400 / 16, 0)
        generationEnd = Vector2(400 / 16, 200 / 8)

    assert(overridesChances.size() == overridesNames.size(), 'overriddes sizes do not match')

    # calculate total chance
    tileOptionsSumChance = emptyChance
    for id in tile_set.get_tiles_ids():
        var name = tile_set.tile_get_name(id)
        tileOptionsSumChance += getChanceForTile(name)

    assert(tileOptionsSumChance > 0, 'tile options sum chance is not more than 0, selection logic math will not work')

    # generate tiles
    for x in range(generationStart.x, generationEnd.x):
        for y in range(generationStart.y, generationEnd.y):
            generateTile(x, y)

func generateTile(x: int, y: int):
    # select a random tile
    var s = rand_range(0, tileOptionsSumChance)
    var i = 0
    var selected = INVALID_CELL

    if s < emptyChance:
        # empty tile
        return

    s -= emptyChance

    var ids = tile_set.get_tiles_ids()

    while s > 0:
        selected = ids[i]

        var name = tile_set.tile_get_name(selected)

        s -= getChanceForTile(name)
        i += 1

    set_cell(x, y, selected)

func getChanceForTile(name: String) -> int:
    for i in range(overridesNames.size()):
        var prefix = overridesNames[i]

        if name.begins_with(prefix):
            return overridesChances[i]

    return defaultChance
