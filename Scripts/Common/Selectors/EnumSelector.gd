extends EnumSelector

@onready var selector : OptionButton = $Selector;
@onready var label : Label = $Label;

func init(label_message : String, new_options : Dictionary, default = null, preselected = null) -> void:
	label.text = label_message;
	options = {
		0: EnumOption.new("–", default)	
	};
	options.merge(new_options);
	for option in options.values():
		selector.add_item(option.message);
	clear();
	if preselected != null:
		preselect(preselected);

func preselect(value) -> void:
	var index : int;
	var found : int = -1;
	for option in options.values():
		if option.value == value:
			found = index;
			break;
		index += 1;
	if found >= 0:
		select(found);
		

func _on_selector_item_selected(index : int) -> void:
	chosen_option = options[index];

func clear() -> void:
	select(0);

func select(index : int) -> void:
	chosen_option = options[index];
	selector.select(index);
