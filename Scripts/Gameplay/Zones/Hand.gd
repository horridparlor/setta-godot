extends Hand

func reorder_cards(gameplay : Gameplay):
	sort_card_position(HAND_HEIGHT, GameplayEnums.OwningPlayer.YOU);
