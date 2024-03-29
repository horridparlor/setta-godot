extends Node
class_name CardData

var card : CardEnums.Card;
var card_class : CardEnums.Class;
var card_type : CardEnums.CardType;
var subtype : CardEnums.CardSubtype;
var special_types : SpecialTypes;
var monster_data : MonsterData;
var effects : CardEffects;
var effect_text : String;
var instance_id : int;

var owning_player : GameplayEnums.OwningPlayer;
var controlling_player : GameplayEnums.OwningPlayer;
var zone : CardEnums.Zone = CardEnums.Zone.NONE;
var face : CardEnums.Face = CardEnums.Face.NONE;

func _init(
	card_ : CardEnums.Card,
	card_class_ : CardEnums.Class,
	card_type_ : CardEnums.CardType,
	subtype_ : CardEnums.CardSubtype,
	special_types_ : SpecialTypes,
	effects_ : CardEffects,
	effect_text_ : String,
	random : RandomNumberGenerator,
	monster_data_ : MonsterData = null
):
	card = card_;
	card_class = card_class_;
	card_type = card_type_;
	subtype = subtype_;
	special_types = special_types_;
	effects = effects_;
	effect_text = effect_text_;
	instance_id = System.Random.instance_id(random);
	zone = CardEnums.Zone.HAND;
	monster_data = monster_data_;
	
