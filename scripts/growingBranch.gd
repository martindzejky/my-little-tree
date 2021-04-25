extends Branch
class_name GrowingBranch

# tree constants
export(Resource) var treeData

# object to spawn when growing new branches
export (String, FILE) var branchToSpawnFile

func _process(delta):
    grow(delta)
    spawnNewBranches(delta)


func grow(delta):
    # small chance to grow the branch
    if randf() < delta * treeData.branchGrowthChance:
        length += rand_range(treeData.branchGrowthAmountMin, treeData.branchGrowthAmountMax)
        length = min(length, treeData.maxGrowthLength)


func spawnNewBranches(delta):
    # respect the max children limit
    var existingChildren = $children.get_child_count()
    if existingChildren >= treeData.maxBranchChildren:
        return

    # decrease the chance even further if there's already a child
    var chanceMultiplier = 1
    if existingChildren > 0:
        chanceMultiplier = 0.8

    # small chance to spawn a new branch
    if randf() < delta * treeData.branchSpawnChance * chanceMultiplier:
        var newBranch = load(branchToSpawnFile).instance() as Branch


        # initialize length and rotation
        newBranch.length = treeData.minGrowthLength

        # avoid overlapping branches when generating the rotation
        while true:
            newBranch.rotation_degrees = rand_range(-treeData.maxGrowthAngle, treeData.maxGrowthAngle)

            var stop = true

            for child in $children.get_children():
                if abs(child.rotation_degrees - newBranch.rotation_degrees) < treeData.minRotationDifference:
                    stop = false

            if stop:
                break

        $children.add_child(newBranch)
