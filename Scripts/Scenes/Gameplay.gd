extends Gameplay

@onready var hand : Hand = $Hand;
@onready var field : Field = $Field;
@onready var sky : Zone = $Sky;

@onready var your_stats : PlayerStats = $Widgets/YourStats;
@onready var opponents_stats : PlayerStats = $Widgets/OpponentsStats;
@onready var extra_deck_stand : CardStand = $Widgets/ExtraDeckStand;

@onready var card_focus_timer : Timer = $Timers/CardFocusTimer;

const CardActions : GDScript = preload("res://Scripts/Scenes/Gameplay/CardActions.gd");
const CardManager : GDScript = preload("res://Scripts/Scenes/Gameplay/CardManager.gd");
const Focuser : GDScript = preload("res://Scripts/Scenes/Gameplay/Focuser.gd");
const GameManager : GDScript = preload("res://Scripts/Scenes/Gameplay/GameManager.gd");
const Widgets : GDScript = preload("res://Scripts/Scenes/Gameplay/Widgets.gd");

func _ready() -> void:
	init_random();
	connect_signals();
	CardManager.init_game_state(self);
	GameManager.start_game(self);

func init_random() -> void:
	random.randomize();

func connect_signals() -> void:
	pass;
	
func _on_card_clicked(card : GameplayCard) -> void:
	Focuser.card_clicked(card, self);

func _on_card_released(card : GameplayCard) -> void:
	Focuser.card_released(card, self);

func _on_card_action(action : CardEnums.CardAction, card : GameplayCard) -> void:
	CardActions.card_action(action, card, self);

func _process(delta : float):
	if !focused_card:
		return;
	elif focused_card.focus_state == GameplayEnums.FocusState.WAITING:
		if System.Vectors.have_distance(get_global_mouse_position(), focus_point, FOCUS_FOLLOW_DISTANCE):
			_on_card_focus_timer_timeout();
		return;
	match focused_card.zone:
		hand:
			hand.reorder_cards(self);

func _on_card_focus_timer_timeout() -> void:
	card_focus_timer.stop();
	if !focused_card:
		return;
	focused_card.Movement.interact(focused_card, self);

func update_player_stats() -> void:
	your_stats.update_stats(game_state.you);
	opponents_stats.update_stats(game_state.opponent);
