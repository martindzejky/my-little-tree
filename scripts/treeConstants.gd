extends Resource
class_name TreeConstants

# ENERGY

export(float) var maxEnergyPerBranch
export(float) var maxEnergyPerRoot
export(float) var energyGainPerLeaf

# WATER

export(float) var maxWaterPerBranch
export(float) var maxWaterPerRoot

# STABILITY

export(float) var stabilityPerBranch
export(float) var stabilityPerRoot

# ROOT GROWTH

export(float) var minGrowthLength
export(float) var maxGrowthLength
export(float) var maxGrowthAngle
export(float) var maxBranchChildren
export(float) var minRotationDifference
export(float) var requiredEnergyForRootGrowth
export(float) var requiredWaterForRootGrowth

# BRANCH GROWTH

export(float) var branchGrowthChance
export(float) var branchGrowthAmountMin
export(float) var branchGrowthAmountMax
export(float) var branchSpawnChance
export(float) var requiredEnergyForBranchGrowth
export(float) var requiredWaterForBranchGrowth
export(float) var requiredEnergyForBranchChild
export(float) var requiredWaterForBranchChild

# GROUND

export(int) var groundWidth
export(int) var groundHeight
