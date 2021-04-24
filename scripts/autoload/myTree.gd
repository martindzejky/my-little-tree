extends Node

# This script is loaded using AutoLoad, it is available always
# and globally. It stores global information about the growing tree.

# ENERGY is gathered from the sun by the tree automatically, based
# on the weather and the day/night cycle.

var currentEnergy = 0
var maxEnergy = 0

# WATER is gathered by the roots from water sources. Also, when it
# is raining, more water is gathered.

var currentWater = 0
var maxWater = 0

# STABILITY is calculated based on the branches and the roots.

var currentStability = 0
var maxStability = 0


# UPDATE stats
func _process(delta):
    var treeNodes = get_tree().get_nodes_in_group('tree')
    assert(treeNodes.size() == 1, 'there is not exactly one tree')

    var tree = treeNodes[0]
    var branches = tree.get_node("branches")
    var roots = tree.get_node("roots")
