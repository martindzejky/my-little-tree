extends Node2D

# placeholder root which is created while a new root
# is grown
export(PackedScene) var rootPlaceholderObject

var isGrowing = false
var placeholder: Branch

func _input(event):

    if event.is_action_pressed('select') and not isGrowing:

        if SelectedRoots.hoveredRoots.size() > 0:
            isGrowing = true
            createPlaceholder()


    if event.is_action_released('select') and isGrowing:
        isGrowing = false
        createRootFromPlaceholder()


    if event.is_action_released('select_cancel') and isGrowing:
        isGrowing = false
        cancelPlaceholder()


func _process(delta):
    if isGrowing and placeholder:
        var targetDistance = get_global_mouse_position() - placeholder.global_position

        placeholder.global_rotation_degrees = rad2deg(targetDistance.angle()) - 90
        placeholder.length = targetDistance.length()
        placeholder.thickness = 1


func createPlaceholder():
    # start growing root from the first selected root
    # TODO: this could check if there are multiple and select the bottom one
    #       but ain't nobody got time for dat!

    assert(SelectedRoots.hoveredRoots.size() > 0, 'no hovered roots in createPlaceholder')
    var rootToGrowFrom = SelectedRoots.hoveredRoots[0] as Branch

    assert(rootToGrowFrom is Branch, 'root to grow from is not a branch')

    if not rootToGrowFrom.playerCanGrow:
        isGrowing = false
        return

    placeholder = rootPlaceholderObject.instance()
    rootToGrowFrom.get_node('children').add_child(placeholder)


func createRootFromPlaceholder():
    pass


func cancelPlaceholder():
    if placeholder:
        placeholder.queue_free()
