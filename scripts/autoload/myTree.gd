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

# MAGIC numbers of updating the resources

var treeData: Resource

func _init():
    treeData = preload('res://data/treeConstants.tres')


# UPDATE stats
func _process(delta):
    var treeNodes = get_tree().get_nodes_in_group('tree')
    assert(treeNodes.size() == 1, 'there is not exactly one tree')

    var tree = treeNodes[0]
    var branches = tree.get_node("branches")
    var roots = tree.get_node("roots")

    # calculate maximum values
    maxEnergy = getBranchValueIn(branches) * treeData.maxEnergyPerBranch + getBranchValueIn(roots) * treeData.maxEnergyPerRoot
    maxWater = getBranchValueIn(branches) * treeData.maxWaterPerBranch + getBranchValueIn(roots) * treeData.maxWaterPerRoot
    maxStability = getBranchValueIn(roots) * treeData.maxStabilityPerRoot

    # update current values

    var energyGain = delta * getLeafValueIn(branches) * treeData.energyGainPerLeaf
    currentEnergy = clamp(
        currentEnergy + energyGain,
        0, maxEnergy)

    # TODO: water

    var stabilityGain = \
        delta * \
            getBranchValueIn(branches) * treeData.stabilityGainPerBranch \
        + delta * \
            getBranchValueIn(roots) * treeData.stabilityGainPerRoot

    currentStability = clamp(
        currentStability + stabilityGain,
        0, maxStability)


func getBranchValueIn(node: Node2D) -> float:
    var branches = node.get_children()
    var counter = 0.0

    for branch in branches:
        counter += branch.thickness * branch.length
        counter += getBranchValueIn(branch.get_node('children'))

    return counter


func getLeafValueIn(node: Node2D) -> float:
    var branches = node.get_children()
    var counter = 0.0

    for branch in branches:
        var children = branch.get_node('children')

        if children.get_child_count() == 0:
            counter += branch.thickness * branch.length

        else:
            counter += getBranchValueIn(children)

    return counter
