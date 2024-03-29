extends Node
class_name CardData

var card : CardEnums.Card;
var card_type : CardEnums.CardType;
var subtype : CardEnums.CardSubtype;
var effects : Array;
var effect_text : String;
var instance_id : int;

var owning_player : GameplayEnums.OwningPlayer;
var zone : CardEnums.Zone = CardEnums.Zone.NONE;
var near_zone : CardEnums.Zone = CardEnums.Zone.NONE;
var atk_gain : int;
var def_gain : int;
var atk_long_gain : int;
var def_long_gain : int;
var keywords : Array;
var long_keywords : Array;

func _init(
	card_ : CardEnums.Card,
	card_type_ : CardEnums.CardType,
	subtype_ : CardEnums.CardSubtype,
	effects_ : Array,
	effect_text_ : String,
	random : RandomNumberGenerator
):
	card = card_;
	card_type = card_type_;
	subtype = subtype_;
	effects = effects_;
	effect_text = effect_text_;
	instance_id = System.Random.instance_id(random);
	zone = CardEnums.Zone.HAND;
	near_zone = CardEnums.Zone.HAND;
