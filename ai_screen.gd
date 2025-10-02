extends Control

@onready var http = $HTTPRequest
@onready var chat_box = $ScrollContainer/ChatBox
@onready var user_input = $UserInput
@onready var send_button = $SendButton

var GEMINI_API_KEY = "YOUR_API_KEY_HERE"
var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + GEMINI_API_KEY

func _ready():
	send_button.connect("pressed", Callable(self, "_on_send_pressed"))
	user_input.connect("text_submitted", Callable(self, "_on_user_input_submitted"))

# --- When user presses Enter or clicks Send ---
func _on_send_pressed():
	if user_input.text.strip_edges() != "":
		_add_message("You", user_input.text, Color(0.2, 0.6, 1))
		ask_ai(user_input.text)
		user_input.text = ""

func _on_user_input_submitted(new_text):
	_on_send_pressed()

# --- Send query to Gemini ---
func ask_ai(user_message: String):
	var headers = ["Content-Type: application/json"]

	var body = {
		"contents": [{
			"role": "user",
			"parts": [{
				"text": "You are a friendly fitness assistant. Motivate and guide the user in their fitness journey with short, practical advice.\n\nUser: " + user_message
			}]
		}]
	}

	var body_json = JSON.stringify(body)  # ✅ correct for Godot 4
	http.request(GEMINI_URL, headers, true, HTTPClient.METHOD_POST, body_json)

# --- Handle Gemini’s reply ---
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result == OK:
		var data = json.data  # <-- parsed dictionary lives here
		if data.has("candidates") and data["candidates"].size() > 0:
			var reply = data["candidates"][0]["content"]["parts"][0]["text"]
			_add_message("AI Coach", reply, Color(0.1, 0.8, 0.3))
		else:
			_add_message("AI Coach", "Sorry, I couldn’t think of anything 😅", Color(0.8, 0.1, 0.1))
	else:
		push_error("JSON parse failed")


# --- Helper: Add messages to the chatbox ---
func _add_message(sender: String, text: String, color: Color):
	var rlbl = RichTextLabel.new()
	rlbl.bbcode_enabled = true
	rlbl.push_color(color)
	rlbl.add_text(sender + ": " + text + "\n")
	rlbl.pop()
	rlbl.scroll_active = true
	rlbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rlbl.percent_visible = 1.0   # show all text immediately
	chat_box.add_child(rlbl)

	# Scroll to bottom
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scrollbar().max_value



	# Scroll to bottom
