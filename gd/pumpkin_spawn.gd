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
		hide() #hidden by default in-game.

func harvest():
	hide()
	var spawned:Array = get_parent().spawned
	#go back into the spawnable zones.
	spawned.remove_at(spawned.find(self))
	get_parent().spawn_points.add(self)
