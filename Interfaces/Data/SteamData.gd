extends Node
class_name SteamData

var steam_id : int;
var auth_ticket : Dictionary;

func _init() -> void:
	steam_id = Steam.getSteamID();
	Steam.endAuthSession(steam_id);
	auth_ticket = Steam.getAuthSessionTicket();
