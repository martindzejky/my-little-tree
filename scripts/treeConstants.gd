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

export(float) var maxStabilityPerRoot
export(float) var stabilityGainPerBranch
export(float) var stabilityGainPerRoot

# GROWTH CONSTANTS
export(float) var newRootThicknessMultiplier
export(float) var parentRootThicknessMultiplier
export(float) var minGrowthLength
export(float) var maxGrowthLength
export(float) var maxGrowthAngle
export(float) var maxBranchChildren
export(float) var minRotationDifference
