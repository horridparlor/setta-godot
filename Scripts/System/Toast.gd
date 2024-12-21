static func make_toast(message : String, theme : SystemEnums.ToastTheme, parent : Node) -> ToastMessage:
	var toast_message : ToastMessage = System.Instance.load_child(ToastMessage.TOAST_MESSAGE_PATH, parent);
	toast_message.init(message, theme);
	return toast_message;
	
