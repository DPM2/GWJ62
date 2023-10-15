extends Node3D

@onready var harvest_progress = $Control/ProgressBar
@onready var ui_part = $Control
@onready var hilight = $Hilight
@onready var spawn : PumpkinSpawn = get_parent()

func _physics_process(delta):
	if Input.is_action_pressed("interact") and hilight.visible:
		ui_part.show() #Show the ui piece for this pumpkin
		harvest_progress.value+=delta #change progress bar value with delta.
		var hval = harvest_progress.value
		if hval >= harvest_progress.max_value:
			spawn.harvest()
			hilight.hide()
			ui_part.hide()
	elif ui_part.visible:
		harvest_progress.value=0
		ui_part.hide()

func _on_harvest_area_body_entered(body):
	if body is PlayerBody:
		hilight.show()


func _on_harvest_area_body_exited(body):
	if body is PlayerBody and hilight.visible:
		hilight.hide()
		if ui_part.visible:
			ui_part.hide()
