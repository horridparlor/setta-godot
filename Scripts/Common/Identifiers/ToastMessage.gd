extends ToastMessage

@onready var backframe : Panel = $Backframe;
@onready var label : Label = $Label;
@onready var despawn_timer : Timer = $Timers/DespawnTimer;
@onready var load_panel : Panel = $LoadPanel;

func _process(delta : float) -> void:
	if instance_id == 0:
		return;
	load_panel.size.x = load_panel_max_x - max(0, despawn_timer.time_left - DESPAWN_EXTRA_WAIT) / despawn_wait * load_panel_max_x;
	fix_position();

func fix_position() -> void:
	backframe.size.x = label.size.x + 2 * BACKFRAME_MARGIN;
	load_panel_max_x = backframe.size.x;
	backframe.position.x = -backframe.size.x / 2;
	load_panel.position.x = backframe.position.x;
	global_position.x = System.Window_.x / 2 - backframe.size.x / 2 - SPAWN_POINT_MARGIN.x;

func init(message : String, theme : SystemEnums.ToastTheme = SystemEnums.ToastTheme.SUCCESS) -> void:
	despawn_wait = DESPAWN_EXTRA_WAIT + (DESPAWN_WAIT_SUCCESS if theme == SystemEnums.ToastTheme.SUCCESS else DESPAWN_WAIT_FAILURE);
	despawn_timer.wait_time = despawn_wait;
	instance_id = System.Random.instance_id();
	label.text = message;
	load_panel.add_theme_stylebox_override("panel", load(get_theme_path(theme)));
	start_from_corner();

func start_from_corner() -> void:
	global_position = System.Window_ / 2 - Vector2(backframe.size.x / 2, 0) - SPAWN_POINT_MARGIN;
	despawn_timer.start();

func _on_despawn_timer_timeout() -> void:
	despawn_timer.stop();
	emit_signal("despawn", instance_id);
