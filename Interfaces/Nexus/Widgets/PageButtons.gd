extends Node2D
class_name PageButtons

signal page_switched(nexus_page);

const PAGE_ICON_PATH : String = "res://Assets/Icons/Nexus/";
const SHOP_PAGE_ICON_PATH : String = PAGE_ICON_PATH + "shop.png";
const DECKS_PAGE_ICON_PATH : String = PAGE_ICON_PATH + "decks.png";
const BATTLE_PAGE_ICON_PATH : String = PAGE_ICON_PATH + "battle.png";
const ROGUE_PAGE_ICON_PATH : String = PAGE_ICON_PATH + "rogue.png";
const NEWS_PAGE_ICON_PATH : String = PAGE_ICON_PATH + "news.png";

var active_button : PageButton;
var is_active : bool;

func toggle_active(value : bool = true) -> void:
	is_active = value;
