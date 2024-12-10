extends Login

@onready var error_label : Label = $ErrorLabel;
@onready var username_input : TextInput = $UsernameInput;
@onready var password_input : TextInput = $PasswordInput;
@onready var submit_button : SubmitButton = $SubmitButton;
@onready var ip_input : TextInput = $IpInput;
@onready var game_title : Control = $GameTitle;

func _ready() -> void:
	error_label.visible = false;
	init_form();
	game_title.glow_node.activate_animations(random);

func init_form() -> void:
	username_input.init("Username", "cuteladyanis");
	username_input.submit.connect(password_input.focus);
	password_input.init("Password", "*****", true);
	password_input.submit.connect(submit_button.press);
	submit_button.init("Login", random);
	submit_button.pressed.connect(on_login);

func init_ip_input() -> void:
	ip_input.init("Server Ip", System.server_ip);
	ip_input.submit.connect(ip_submitted);

func ip_submitted() -> void:
	ip_input.unfocus();
	var ip : String = ip_input.get_text();
	System.server_ip = ip if !ip.is_empty() else System.Server.DEFAULT_SERVER_IP;

func init(error_message : String = "") -> void:
	set_error(error_message);
	if System.auth_data:
		username_input.set_text(System.auth_data.username);
		password_input.set_text(System.auth_data.password);
	username_input.focus();
	init_ip_input();

func set_error(message : String = "") -> void:
	error_label.visible = !message.is_empty();
	error_label.text = message;

func on_login() -> void:
	set_error();
	var username = username_input.get_text();
	var password = password_input.get_text();
	if !ip_input.get_text().is_empty():
		ip_submitted();
	if username.is_empty():
		username_input.focus();
		set_error('Username required');
		return;
	elif password.is_empty():
		password_input.focus();
		set_error('Password required');
		return;
	System.Server.request(RequestEnums.Operation.AUTHENTICATE, {
		'username': username,
		'password': password
	}, self);

func _on_http_response(operation : RequestEnums.Operation, response : Dictionary) -> void:
	match operation:
		RequestEnums.Operation.AUTHENTICATE:
			if response.has('error'):
				set_error(response.error);
				return;
			System.Auth.store_auth(AuthData.new(
				username_input.get_text(),
				password_input.get_text(),
				response.authToken,
				response.userId,
				response.firstname,
				response.lastname,
				response.accessRights
			));
			emit_signal("authenticated");
