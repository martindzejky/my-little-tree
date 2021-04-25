extends MarginContainer

# this is the name of a variable on MyTree to display
export(String) var resourceName
export(String) var resourceMaxName

func _process(delta):
    var currentValue = int(MyTree.get(resourceName))
    var maxValue = int(MyTree.get(resourceMaxName))

    $container/meter.value = currentValue
    $container/meter.max_value = maxValue
