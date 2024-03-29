extends Home

func _ready():
	System.Instance.load_child(GAMEPLAY_PATH, self);

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();
