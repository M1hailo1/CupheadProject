extends Node2D

var boss_triggered = false

func _on_boss_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not boss_triggered:
		boss_triggered = true
		$LevelMusic.stop()
		$BossMusic.play()
		var camera = body.get_node("Camera2D")
		camera.limit_left = 2300
		camera.limit_right = 3380
		$LeftBossWall.position.x = 2550
		var boss = get_tree().get_root().find_child("WernerBoss", true, false)
		boss.boss_fight_started = true

func _process(delta: float) -> void:
	GameManager.time_elapsed += delta
