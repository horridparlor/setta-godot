extends Node2D
class_name Nexus

signal enter_game();
signal logout();

const PAGES_PATH : String = "res://Prefabs/Nexus/Pages/";
const SHOP_PAGE_PATH : String = PAGES_PATH + "ShopPage.tscn";
const DECKS_PAGE_PATH : String = PAGES_PATH + "DecksPage.tscn";
const BATTLE_PAGE_PATH : String = PAGES_PATH + "BattlePage.tscn";
const ROGUE_PAGE_PATH : String = PAGES_PATH + "RoguePage.tscn";
const NEWS_PAGE_PATH : String = PAGES_PATH + "NewsPage.tscn";

const PAGE_SLIDE_SPEED : float = 6;
const PAGE_AWAY_MIN_SPEED : float = 600;
const PAGE_SLIDE_STOP_BLOCKING_DISTANCE : float = System.Window_.x / 2;
const PAGE_BUTTONS_BASE_Y : float = 420;
const PAGE_BUTTONS_HIDDEN_Y : float = 710;
const PAGE_BUTTONS_SLIDE_SPEED_UP : float = 4;
const PAGE_BUTTONS_SLIDE_MIN_SPEED_UP : float = 0;
const PAGE_BUTTONS_SLIDE_SPEED_DOWN : float = 1;
const PAGE_BUTTONS_SLIDE_MIN_SPEED_DOWN : float = 200;

var random : RandomNumberGenerator = RandomNumberGenerator.new();
var active_page : NexusPage;
var previous_page : NexusPage;
var is_moving_pages : bool;
var is_moving_pages_blockingly : bool;
var page_slide_direction : int;
var is_moving_page_buttons : bool;
var page_buttons_target_position : Vector2;
var page_buttons_hidden : bool;

func _ready() -> void:
	random.randomize();
