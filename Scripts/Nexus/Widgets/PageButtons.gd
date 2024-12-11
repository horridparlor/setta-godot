extends PageButtons

@onready var shop_button : PageButton = $ShopButton;
@onready var decks_button : PageButton = $DecksButton;
@onready var battle_button : PageButton = $BattleButton;
@onready var rogue_button : PageButton = $RogueButton;
@onready var news_button : PageButton = $NewsButton;

func get_buttons() -> Array:
	return [
		shop_button,
		decks_button,
		battle_button,
		rogue_button,
		news_button
	];

func _ready() -> void:
	init_buttons();

func init(random : RandomNumberGenerator) -> void:
	for b in get_buttons():
		var button : PageButton = b;
		button.activate_animations(random);
	is_active = true;
	on_button_pressed(battle_button);

func init_buttons() -> void:
	shop_button.init(NexusEnums.NexusPage.SHOP, SHOP_PAGE_ICON_PATH);
	decks_button.init(NexusEnums.NexusPage.DECKS, DECKS_PAGE_ICON_PATH);
	battle_button.init(NexusEnums.NexusPage.BATTLE, BATTLE_PAGE_ICON_PATH);
	rogue_button.init(NexusEnums.NexusPage.ROGUE, ROGUE_PAGE_ICON_PATH);
	news_button.init(NexusEnums.NexusPage.NEWS, NEWS_PAGE_ICON_PATH);
	for b in get_buttons():
		var button : PageButton = b;
		button.pressed.connect(on_button_pressed);

func on_button_pressed(button : PageButton) -> void:
	if !is_active:
		return;
	if active_button:
		if button == active_button:
			return;
		active_button.toggle_active(false);
	button.toggle_active();
	active_button = button;
	is_active = false;
	emit_signal("page_switched", button.nexus_page);
