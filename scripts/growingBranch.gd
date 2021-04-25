extends Branch
class_name GrowingBranch

# tree constants
export(Resource) var treeData

# object to spawn when growing new branches
export (String, FILE) var branchToSpawnFile

var maxGrown = false
var maxChildren = false

func _process(delta):
    grow(delta)
    spawnNewBranches(delta)


func grow(delta):
    if maxGrown:
        return

    # base the chance on the current stability
    var chance = delta * treeData.branchGrowthChance
    chance = lerp(0, chance, MyTree.currentStability / 100)

    # small chance to grow the branch
    if randf() < chance:
        length += rand_range(treeData.branchGrowthAmountMin, treeData.branchGrowthAmountMax)

    if length > treeData.maxGrowthLength:
        length = treeData.maxGrowthLength
        maxGrown = true


func spawnNewBranches(delta):
    if maxChildren:
        return

    # respect the max children limit
    var existingChildren = $children.get_child_count()
    if existingChildren >= treeData.maxBranchChildren:
        maxChildren = true
        return

    # base the chance on the current stability
    var chance = delta * treeData.branchSpawnChance
    chance = lerp(0, chance, MyTree.currentStability / 100)

    # decrease the chance even further if there's already a child
    if existingChildren > 0:
        chance *= 0.8

    # small chance to spawn a new branch
    if randf() < chance:
        var newBranch = load(branchToSpawnFile).instance() as Branch


        # initialize length and rotation
        newBranch.length = treeData.minGrowthLength

        # avoid overlapping branches when generating the rotation
        var try = 10
        while true:
            # limit retries
            if try < 0:
                newBranch.queue_free()
                return

            try -= 1

            newBranch.rotation_degrees = rand_range(-treeData.maxGrowthAngle, treeData.maxGrowthAngle)

            var stop = true

            for child in $children.get_children():
                if abs(child.rotation_degrees - newBranch.rotation_degrees) < treeData.minRotationDifference:
                    stop = false

            if stop:
                break

        $children.add_child(newBranch)
