static func connect_signals(gameplay : Gameplay) -> void:
	connect_card_stands(gameplay);

static func connect_card_stands(gameplay : Gameplay) -> void:
	var extra_deck_stand : CardStand = gameplay.Widgets.get_card_stand(
		GameplayEnums.WidgetType.EXTRA_DECK, gameplay);
	extra_deck_stand.pressed.connect(gameplay._on_widget_pressed);
	extra_deck_stand.released.connect(gameplay._on_widget_released);
