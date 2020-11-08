extends CollisionShape2D

const TWO_PI = 2.0 * PI

const speed = 300
const turn_speed = 3
const max_bounces = 3

var bounces = 0


func move(target_node, phys_delta):
	var m = get_parent()
	# TODO: maybe check if the target_node exists
	var target_rotation = m.get_angle_to(target_node.global_position)
	m.rotation += lerp(0, target_rotation, turn_speed) * phys_delta
	
	# Always fly forward
	m.position += m.transform.basis_xform(Vector2.RIGHT) * speed * phys_delta
	# Apply sinoid wave
	var up = m.transform.basis_xform(Vector2.UP)
	m.position += up * sin(Engine.get_frames_drawn() / 5.0)


# explode() returns a number between 0.0 and 1.0 determining how much
# damage the missile should do. It also performs an animation before freeing
# the parent node.
# NOTE: Was previously known as "get_damage()"
func explode() -> float:
	# TODO: an animation
	# TODO: could probably do a great, negative gravity on this Area2D to simulate physical force
	# TODO: timer / end of animation we get_parent().queue_free()
	get_parent().queue_free() # ... for now ;)
	
	# + 1 because if it hasn't bounced it must still do damage
	return (bounces / float(max_bounces) + 1)


func can_deflect() -> bool:
	return bounces < max_bounces


# Let the missile know it got deflected
func deflected() -> void:
	bounces += 1
