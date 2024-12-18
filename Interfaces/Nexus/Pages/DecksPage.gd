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
const CARD_CATALOGUE_SCROLL_MULTIPLIER : float = 3;
const CARD_CATALOGUE_MIN_SCROLL : int = 40;
const CARD_CATALOGUE_MAX_CARDS_SHOWN : int = (CARD_CATALOGUE_ROWS_SHOWN + 2) * CARD_CATALOGUE_COLUMNS;
const CARD_CATALOGUE_SPAWN_POINT : Vector2 = Vector2(
	CARD_CATALOGUE_STARTING_POSITION.x + CARD_CATALOGUE_COLUMNS / 2.0 * CARD_CATALOGUE_MARGINS.x,
	CARD_CATALOGUE_ROWS * CARD_CATALOGUE_MARGINS.y
);
const CARD_CATALOGUE_TOP_SPAWN_POINT : Vector2 = Vector2(CARD_CATALOGUE_SPAWN_POINT.x, -(CARD_CATALOGUE_ROWS - 1) * CARD_CATALOGUE_MARGINS.y)

const DECKLIST_SCROLL_SPEED : float = 4;
const DECKLIST_MIN_SCROLL : int = 40;
const DECKLIST_SCROLL_MULTIPLIER : float = 2;
const DECKLIST_FORM_MAX_Y : float = -257;
const DECKLIST_FORM_DEFAULT_RANGE : float = System.Window_.y - abs(DECKLIST_FORM_MAX_Y);

var in_edit_mode : bool;
var card_catalogue_grid : Grid = Grid.new(
	CARD_CATALOGUE_STARTING_POSITION, CARD_CATALOGUE_COLUMNS,
	CARD_CATALOGUE_MARGINS, CARD_CATALOGUE_MAX_CARDS_SHOWN);
var is_scrolling_catalogue : bool;
var is_scrolling_decklist : bool;
var catalogue_scroll_position : Vector2;
var catalogue_scroll_start_position : Vector2;
var catalogue_layer_target_position : Vector2;
var is_moving_catalogue_layer : bool;
var catalogue_layer_max_y : float;
var catalogue_cards : Array;
var first_row_shown : int;
var last_row_shown : int;
var first_card_shown : int;
var last_card_shown : int;
var cards_in_grid : Dictionary;
var previously_focused_card_id : int;

var is_moving_decklist_layer : bool;
var decklist_scroll_start_position : Vector2;
var decklist_scroll_position : Vector2;
var decklist_form_target_position : Vector2;
var cards_in_decklist : Dictionary;
var all_cards : Array = System.CardData.get_all_cards();
var chosen_deck_master : CardData;

func toggle_edit_mode(value : bool = true) -> void:
	in_edit_mode = value;
	on_edit_mode_changed();

func on_edit_mode_changed() -> void:
	pass;
