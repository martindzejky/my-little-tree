extends MarginContainer

# this is the name of a variable on MyTree to display
export(String) var resourceName
export(String) var resourceMaxName

func _process(delta):
    var currentValue = MyTree.get(resourceName)
    var maxValue = MyTree.get(resourceMaxName)

    $container/value.text = String(currentValue) + ' / ' + String(maxValue)
