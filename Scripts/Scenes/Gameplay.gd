extends Gameplay

@onready var hand : Hand = $Hand;
@onready var field : Field = $Field;
@onready var sky : Zone = $Sky;
@onready var extra_deck : Zone = $Widgets/ExtraDeckStand/ExtraDeck;
@onready var grave : Zone = $Grave;
@onready var modal : Zone = $Scroller/Modal;
@onready var scroller : Scroller = $Scroller;

@onready var your_stats : PlayerStats = $Widgets/PlayerStats/YourStats;
@onready var opponents_stats : PlayerStats = $Widgets/PlayerStats/OpponentsStats;
@onready var extra_deck_stand : CardStand = $Widgets/ExtraDeckStand;
@onready var player_stats : GlowNode = $Widgets/PlayerStats;
@onready var action_hint : ActionHint = $Widgets/ActionHint;
@onready var cancel_button_layer : GlowNode = $Widgets/GlowNode;

@onready var card_focus_timer : Timer = $Timers/CardFocusTimer;
@onready var zone_focus_timer : Timer = $Timers/ZoneFocusTimer;

const CardActions : GDScript = preload("res://Scripts/Scenes/Gameplay/CardActions.gd");
const CardManager : GDScript = preload("res://Scripts/Scenes/Gameplay/CardManager.gd");
const Focuser : GDScript = preload("res://Scripts/Scenes/Gameplay/Focuser.gd");
const GameManager : GDScript = preload("res://Scripts/Scenes/Gameplay/GameManager.gd");
const Selection : GDScript = preload("res://Scripts/Scenes/Gameplay/Selection.gd");
const Signals : GDScript = preload("res://Scripts/Scenes/Gameplay/Signals.gd");
const Timers : GDScript = preload("res://Scripts/Scenes/Gameplay/Timers.gd");
const Widgets : GDScript = preload("res://Scripts/Scenes/Gameplay/Widgets.gd");

func _ready() -> void:
	init_random();
	Signals.connect_signals(self);
	CardManager.init_game_state(self);
	cancel_button_layer.activate_animations(random);

func init() -> void:
	GameManager.start_game(self);

func init_random() -> void:
	random.randomize();
	
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
	match focus_on:
		GameplayEnums.FocusOn.CARD:
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
	Selection.update_selectable(self);

func _on_widget_pressed(widget_type : GameplayEnums.WidgetType) -> void:
	Widgets.widget_pressed(widget_type, self);

func _on_widget_released(widget_type : GameplayEnums.WidgetType) -> void:
	Widgets.widget_released(widget_type, self);

func _on_zone_focus_timer_timeout() -> void:
	Widgets.zone_focus_timeout(self);

func after_release() -> void:
	Selection.update_selectable(self);
