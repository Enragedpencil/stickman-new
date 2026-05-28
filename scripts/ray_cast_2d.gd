extends RayCast2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collide_with_areas: bool = true
	var collide_with_bodies: bool = true
	var exclude_parent: bool = true
	var hit = get_collider()
	
