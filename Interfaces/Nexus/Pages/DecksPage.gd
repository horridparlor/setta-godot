extends NexusPage
class_name DecksPage

signal edit_deck();
signal close_deck();

const CARD_CATALOGUE_STARTING_POSITION : Vector2 = Vector2(-840, -145);
const CARD_CATALOGUE_COLUMNS : int = 5;
const CARD_CATALOGUE_ROWS : float = 2.72;
const CARD_CATALOGUE_ROWS_SHOWN : int = round(CARD_CATALOGUE_ROWS);
const CARD_CATALOGUE_MARGIN : int = 10;
const CARD_CATALOGUE_MARGINS : Vector2 = GameplayCard.BASE_SCALE * GameplayCard.SIZE + Vector2(CARD_CATALOGUE_MARGIN, CARD_CATALOGUE_MARGIN);
const CARD_CATALOGUE_SCROLL_SPEED : float = 2;
const CARD_CATALOGUE_SCROLL_MULTIPLIER : float = 4;
const CARD_CATALOGUE_MIN_SCROLL : int = 60;
const CARD_CATALOGUE_MAX_CARDS_SHOWN : int = (CARD_CATALOGUE_ROWS_SHOWN + 3) * CARD_CATALOGUE_COLUMNS;
const CARD_CATALOGUE_SPAWN_POINT : Vector2 = Vector2(
	CARD_CATALOGUE_STARTING_POSITION.x + CARD_CATALOGUE_COLUMNS / 2.0 * CARD_CATALOGUE_MARGINS.x,
	CARD_CATALOGUE_ROWS * CARD_CATALOGUE_MARGINS.y
);
const CARD_CATALOGUE_TOP_SPAWN_POINT : Vector2 = Vector2(CARD_CATALOGUE_SPAWN_POINT.x, -CARD_CATALOGUE_SPAWN_POINT.y)

const DECKLIST_SCROLL_SPEED : float = 4;

var in_edit_mode : bool;
var card_catalogue_grid : Grid = Grid.new(
	CARD_CATALOGUE_STARTING_POSITION, CARD_CATALOGUE_COLUMNS,
	CARD_CATALOGUE_MARGINS, CARD_CATALOGUE_MAX_CARDS_SHOWN);
var is_scrolling_catalogue : bool;
var is_scrolling_decklist : bool;
var scroll_position : Vector2;
var catalogue_scroll_start_position : Vector2;
var catalogue_layer_target_position : Vector2;
var is_moving_catalogue_layer : bool;
var is_moving_decklist_layer : bool;
var catalogue_layer_max_y : float;
var catalogue_cards : Array;
var first_row_shown : int;
var last_row_shown : int;
var first_card_shown : int;
var last_card_shown : int;
var cards_in_grid : Dictionary;

func toggle_edit_mode(value : bool = true) -> void:
	in_edit_mode = value;
	on_edit_mode_changed();

func on_edit_mode_changed() -> void:
	pass;
