extends CharacterBody3D

var health=25

func enemy_hit(damage):
	health-=damage
	if health<=0:
		queue_free()
