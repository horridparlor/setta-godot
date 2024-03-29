extends Gameplay

@onready var hand : Hand = $Hand;
@onready var field : Field = $Field;
@onready var sky : Node2D = $Sky;

const CardManager : GDScript = preload("res://Interfaces/Scenes/Gameplay/CardManager.gd");
const GameManager : GDScript = preload("res://Interfaces/Scenes/Gameplay/GameManager.gd");

func _ready() -> void:
	init_random();
	connect_signals();
	starting_player = get_starting_player();
	CardManager.build_decks(self);
	GameManager.start_turn(self);
	for card in player_1.cards_in_hand:
		GameManager.instance_card(card, hand, self);

func init_random() -> void:
	random.randomize();

func connect_signals() -> void:
	hand.rotated.connect(_on_hand_rotated);

func _on_hand_rotated() -> void:
	GameManager.rotation_ready(self);

func _on_card_clicked(card : GameplayCard) -> void:
	if is_invalid_click(card):
		return;
	focused_card = card;
	card.Movement.focused(card);
	set_focused_zone(card.zone);

func is_invalid_click(card : GameplayCard) -> bool:
	return focused_card != null || card.zone in [null, sky];

func _on_card_released(card : GameplayCard) -> void:
	if card == focused_card:
		focused_card = null;
	card.Movement.unfocused(card);
	set_focused_zone();
	
func _on_update_card_playstate(card : GameplayCard) -> void:
	if card.card_data.near_zone == CardEnums.Zone.HAND:
		field.lick_card(card, self);
		hand.reorder_cards(self);
	else:
		hand.lick_card(card, self);
		field.reorder_cards(self);

func set_focused_zone(zone : Zone = hand) -> void:
	System.Children.focus(zone, self);

func _process(delta : float) -> void:
	if focused_card != null:
		hand.reorder_cards(self);

func _on_controls_pass_turn() -> void:
	GameManager.pass_turn(self);

func _on_controls_update_stats() -> void:
	GameManager.update_stats(self);

func get_zones() -> Array:
	return [field, hand];
