extends Control

@onready var EyesContainer : HBoxContainer = get_node("SafeAreaRect/EyesContainer")
@onready var Eye : SubViewportContainer = EyesContainer.get_node("Eye")
@onready var SphereViewer : Node3D = Eye.get_node("SubViewport/SphereViewer")

func one_eye():
	var eyes : Array = get_tree().get_nodes_in_group("eyes")
	if eyes.size() > 1:
		disconnect_cameras()
		eyes.pop_front()
		for eye in eyes:
			eye.queue_free()

func add_eye():
	var neweye : SubViewportContainer = Eye.duplicate()
	EyesContainer.add_child(neweye)

func connect_cameras():
	var cameras : Array = get_tree().get_nodes_in_group("camera")
	var remote : RemoteTransform3D
	var i : int
	var j : int
	
	if cameras.size() > 1:
		i = 0
		while i < cameras.size():
			j = 0
			while j < cameras.size():
				if j!=i:
					remote = RemoteTransform3D.new()
					remote.add_to_group("remotes")
					remote.update_scale = false
					remote.remote_path = cameras[j].get_path()
					cameras[i].add_child(remote)
				j+=1
			i+=1

func disconnect_cameras():
	get_tree().call_group("remotes", "queue_free")

func vr_mode():
	one_eye()
	add_eye()
	connect_cameras()

func vr_3d_mode():
	vr_mode()
	var cameras = get_tree().get_nodes_in_group("camera")
	cameras[1].rotation_degrees.y = 90
	cameras[1].current = false
