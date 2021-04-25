extends Resource
class_name TileOption

# Describes a single tile option with a tile name
# and the associated chance to spawn.

export(String) var name
export(int, 0, 1000) var chance
