@tool
extends Marker3D
class_name PumpkinSpawn

func _ready():
	if Engine.is_editor_hint():
		#code for editor
		if get_children().size() == 0:
			var new_pumpkins = load("res://objects/pumpkin_patch.tscn").instantiate()
			add_child(new_pumpkins) #create the pumpkin mesh inside the editor.
			new_pumpkins.set_owner(get_tree().get_edited_scene_root()) #show in the editor.
	else:
		get_child(0).disable() #hidden by default in-game.

func harvest():
	get_child(0).disable()
	var spawned:Array = get_parent().spawned
	#go back into the spawnable zones.
	var my_index = spawned.find(self)
	if my_index > -1:
		spawned.remove_at(my_index)
	get_parent().spawn_points.append(self)
