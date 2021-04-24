extends Node2D
class_name MainCamera

export(float) var moveSpeed
export(float) var zoomSpeed

var movingCameraGrab = false
var mouseGrabStart = Vector2()
var cameraGrabStart = Vector2()

func _process(delta):

    # get movement input
    var velocity = Vector2.ZERO

    if (Input.is_action_pressed('move_left')):
        velocity.x -= 1
    if (Input.is_action_pressed('move_right')):
        velocity.x += 1
    if (Input.is_action_pressed('move_up')):
        velocity.y -= 1
    if (Input.is_action_pressed('move_down')):
        velocity.y += 1

    # normalize the vector so diagonal movement is not faster
    velocity = velocity.normalized()

    # apply the movement
    position += velocity * delta * moveSpeed * $camera.zoom.x

func _input(event):
    if event.is_action('zoom_in'):
        var newZoom = $camera.zoom.x / zoomSpeed
        $camera.zoom = Vector2(newZoom, newZoom)

    if event.is_action('zoom_out'):
        var newZoom = $camera.zoom.x * zoomSpeed
        $camera.zoom = Vector2(newZoom, newZoom)
