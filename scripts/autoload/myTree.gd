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
# It is always between 0-100 as a percentage. The tree will not
# grow if the stability is too low.

var currentStability = 0
var maxStability = 100

# MAGIC numbers of updating the resources

var treeData: Resource
var initialized = false

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

    # update current values

    var energyGain = delta * getLeafValueIn(branches) * treeData.energyGainPerLeaf
    currentEnergy = clamp(
        currentEnergy + energyGain,
        0, maxEnergy)

    currentWater = clamp(
        currentWater,
        0, maxWater
       )

    var stability = \
          getBranchValueIn(branches) * treeData.stabilityPerBranch \
        + getBranchValueIn(roots) * treeData.stabilityPerRoot

    currentStability = clamp(
        stability,
        0, maxStability)

    # initialize resources to their max values
    if not initialized:
        initialized = true
        currentEnergy = maxEnergy
        currentWater = maxWater


func getBranchValueIn(node: Node2D) -> float:
    var branches = node.get_children()
    var counter = 0.0

    for branch in branches:
        # super HACK to ignore placeholder branches
        if branch.has_node('placeholder'):
            continue

        counter += branch.thickness * branch.length
        counter += getBranchValueIn(branch.get_node('children'))

    return counter


func getLeafValueIn(node: Node2D) -> float:
    var branches = node.get_children()
    var counter = 0.0

    for branch in branches:
        # super HACK to ignore placeholder branches
        if branch.has_node('placeholder'):
            continue

        var children = branch.get_node('children')

        if children.get_child_count() == 0:
            counter += branch.thickness * branch.length

        else:
            counter += getBranchValueIn(children)

    return counter
