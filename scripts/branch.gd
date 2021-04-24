extends Node2D
class_name Branch

# direction in which the branch/root grows.
# -1 is for branches growing up
#  1 is for roots growing down
export(int, -1, 1) var growDirection

# how long is the branch, this might change in time
export(float) var length

# how big (thick) is the branch, this might change in time
export(float) var thickness
