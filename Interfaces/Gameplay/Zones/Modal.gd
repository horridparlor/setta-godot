extends Zone
class_name GameplayModalZone

const MODAL_HEIGHT : int = 0;
const MODAL_WIDTH : int = 1400;

func get_min_y() -> int:
	return -GameplayCard.MODAL_SCALE * CARD_MARGIN_VECTOR.y;

func get_max_y() -> int:
	return GameplayCard.MODAL_SCALE * (count_cards() / CARDS_PER_SCROLL_ROW * CARD_MARGIN_VECTOR.y);
