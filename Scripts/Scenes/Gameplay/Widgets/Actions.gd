static func widget_pressed(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	match widget_type:
		GameplayEnums.WidgetType.EXTRA_DECK:
			show_extra_deck(gameplay);

static func widget_released(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	match widget_type:
		GameplayEnums.WidgetType.EXTRA_DECK:
			hide_extra_deck(gameplay);

static func show_extra_deck(gameplay : Gameplay) -> void:
	var cards : Array = gameplay.game_state.you.cards_in_extra_deck;
	gameplay.GameManager.render_cards(cards, gameplay.extra_deck, gameplay);

static func hide_extra_deck(gameplay : Gameplay) -> void:
	var cards : Array = gameplay.game_state.you.cards_in_extra_deck;
	gameplay.GameManager.delete_cards(cards, gameplay.sky, gameplay);
