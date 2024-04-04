static func card_clicked(card : GameplayCard, gameplay : Gameplay) -> void:
	if is_invalid_click(card, gameplay):
		return;
	if gameplay.focused_card != null:
		unfocus_card(gameplay.focused_card, gameplay);
	focus_card(card, gameplay);

static func is_invalid_click(card : GameplayCard, gameplay : Gameplay) -> bool:
	if card == gameplay.focused_card:
		gameplay.Timers.start(GameplayEnums.TimerType.CardFocus, gameplay);
		return true;
	if gameplay.focus_on not in [
		GameplayEnums.FocusOn.CARD,
		GameplayEnums.FocusOn.NONE,
		GameplayEnums.FocusOn.MODAL
	]:
		true;
	if gameplay.focus_on == GameplayEnums.FocusOn.MODAL and card.zone != gameplay.modal:
		return true;
	return (gameplay.focused_card != null \
		and (gameplay.focused_card.focus_state != GameplayEnums.FocusState.EXAMINE \
			or card.card_data.zone != gameplay.focused_card.card_data.zone)) \
		|| card.zone in [null, gameplay.sky];

static func card_released(card : GameplayCard, gameplay : Gameplay) -> void:
	if card != gameplay.focused_card:
		return;
	gameplay.Timers.stop(GameplayEnums.TimerType.CardFocus, gameplay);
	if card.focus_state in [
		GameplayEnums.FocusState.EXAMINE,
		GameplayEnums.FocusState.INTERACT,
	]:
		unfocus_card(card, gameplay);
	else:
		examine_card(card, gameplay);

static func focus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.focus_point = gameplay.get_global_mouse_position();
	gameplay.focused_card = card;
	focus_on_card(card, gameplay);
	set_focused_zone(card.zone, gameplay);
	gameplay.Timers.start(GameplayEnums.TimerType.CardFocus, gameplay);

static func focus_on_card(card : GameplayCard, gameplay : Gameplay) -> void:
	card.Movement.focus(card);
	gameplay.focus_on = GameplayEnums.FocusOn.CARD;

static func unfocus_card(card : GameplayCard, gameplay : Gameplay) -> void:
	var was_interacted : bool = card.do_interact();
	if card == gameplay.focused_card:
		gameplay.focused_card = null;
	card.Movement.unfocus(card, gameplay);
	if was_interacted:
		card.zone.reorder_cards(gameplay);
	release_focus(gameplay);

static func release_focus(gameplay : Gameplay) -> void:
	set_focused_zone(
		gameplay.modal if gameplay.active_widget != GameplayEnums.WidgetType.NONE 
			else gameplay.hand, gameplay);
	gameplay.release_focus();

static func examine_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if gameplay.is_selecting() and !card.Core.is_selectable(card, gameplay):
		unfocus_card(card, gameplay);
		return;
	match card.card_data.zone:
		CardEnums.Zone.FIELD:
			if gameplay.selection_type == GameplayEnums.SelectionType.TRIBUTE:
				try_tribute_card(card, gameplay);
			return;
		CardEnums.Zone.HAND:
			try_play_card(card, gameplay);
			return;
	unfocus_card(card, gameplay);
	
static func try_play_card(card : GameplayCard, gameplay : Gameplay) -> void:
	if !card.Rules.can_be_played(card, gameplay):
		unfocus_card(card, gameplay);
		return;
	open_modal(GameplayEnums.CardModalType.SUMMON, card, gameplay);

static func open_modal(
	modal_type : GameplayEnums.CardModalType, card : GameplayCard, gameplay : Gameplay
) -> void:
	gameplay.active_modal = modal_type;
	card.Movement.examine(card, gameplay);

static func try_tribute_card(card : GameplayCard, gameplay : Gameplay) -> void:
	open_modal(GameplayEnums.CardModalType.TRIBUTE, card, gameplay);

static func set_focused_zone(zone : Zone, gameplay : Gameplay) -> void:
	System.Children.focus(zone, gameplay);
	if gameplay.active_widget == GameplayEnums.WidgetType.NONE:
		zone.reorder_cards(gameplay);
