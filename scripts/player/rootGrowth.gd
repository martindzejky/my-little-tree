extends Node2D

var isGrowing = false

func _input(event):

    if event.is_action_pressed('root_growth') and not isGrowing:
        isGrowing = true


    if event.is_action_released('root_growth') and isGrowing:
        isGrowing = false


    if event.is_action_released('root_growth_cancel') and isGrowing:
        isGrowing = false
