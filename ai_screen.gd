####extends Control
####
####@onready var http = $HTTPRequest
####@onready var chat_box = $ScrollContainer/ChatBox
####@onready var user_input = $UserInput
####@onready var send_button = $SendButton
####
####var GEMINI_API_KEY = "AIzaSyCw8igJ_vieiXGEgyb_ObzDcFdXp1_bOa4"
####var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + GEMINI_API_KEY
####
####func _ready():
	####send_button.connect("pressed", Callable(self, "_on_send_pressed"))
	####user_input.connect("text_submitted", Callable(self, "_on_user_input_submitted"))
####
##### --- When user presses Enter or clicks Send ---
####func _on_send_pressed():
	####if user_input.text.strip_edges() != "":
		####_add_message("You", user_input.text, Color(0.2, 0.6, 1))
		####ask_ai(user_input.text)
		####user_input.text = ""
####
####func _on_user_input_submitted(new_text):
	####_on_send_pressed()
####
##### --- Send query to Gemini ---
####func ask_ai(user_message: String):
	####var headers = ["Content-Type: application/json"]
####
	####var body = {
		####"contents": [{
			####"role": "user",
			####"parts": [{
				####"text": "You are a friendly fitness assistant. Motivate and guide the user in their fitness journey with short, practical advice.\n\nUser: " + user_message
			####}]
		####}]
	####}
####
	####var body_json = JSON.stringify(body)  # ✅ correct for Godot 4
	####http.request(GEMINI_URL, headers, true, HTTPClient.METHOD_POST, body_json)
####
##### --- Handle Gemini’s reply ---
####func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	####var json = JSON.new()
	####var parse_result = json.parse(body.get_string_from_utf8())
	####if parse_result == OK:
		####var data = json.data  # <-- parsed dictionary lives here
		####if data.has("candidates") and data["candidates"].size() > 0:
			####var reply = data["candidates"][0]["content"]["parts"][0]["text"]
			####_add_message("AI Coach", reply, Color(0.1, 0.8, 0.3))
		####else:
			####_add_message("AI Coach", "Sorry, I couldn’t think of anything 😅", Color(0.8, 0.1, 0.1))
	####else:
		####push_error("JSON parse failed")
####
####
##### --- Helper: Add messages to the chatbox ---
####func _add_message(sender: String, text: String, color: Color):
	####var rlbl = RichTextLabel.new()
	####rlbl.bbcode_enabled = true
	####rlbl.push_color(color)
	####rlbl.add_text(sender + ": " + text + "\n")
	####rlbl.pop()
	####rlbl.scroll_active = true
	####rlbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#####rlbl.percent_visible = 1.0   # show all text immediately
	####chat_box.add_child(rlbl)
####
	##### Scroll to bottom
	####$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scrollbar().max_value
####
####
####
	##### Scroll to bottom
###extends Control
###
#### --- Node References ---
###@onready var http = $HTTPRequest # Ensure this node exists and is connected
###@onready var chat_box = $ScrollContainer/ChatBox # This should be the VBoxContainer *inside* the ScrollContainer
###@onready var user_input = $UserInput
###@onready var send_button = $SendButton
###
#### --- API Configuration ---
#### 🚨 SECURITY WARNING: Replace with your actual key. 
#### Load this securely from a file or environment variable in a production app.
###var GEMINI_API_KEY = "AIzaSyANq4FmN31r9216WXNn9cm9vVbOaAsZdXg" 
###var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY
###
#### 🚨 CRITICAL: This array stores the full conversation history.
###var chat_history: Array = [] 
###
#### --- Initialization ---
###func _ready():
	#### Connect signals using the modern Godot 4 Callable syntax
	###send_button.pressed.connect(Callable(self, "_on_send_pressed"))
	#### Allows pressing Enter in the LineEdit to send the message
	###user_input.text_submitted.connect(Callable(self, "_on_send_pressed")) 
	#### Connect the HTTPRequest completion signal to the handler function
	###http.request_completed.connect(Callable(self, "_on_HTTPRequest_request_completed"))
###
#### --- User Input Handlers ---
###func _on_send_pressed():
	###var message = user_input.text.strip_edges()
	###if message.is_empty():
		###return
		###
	#### 1. Add user message to UI
	###_add_message("You", message, Color(0.2, 0.6, 1))
	###
	#### 2. Add message to the history for the API payload
	###chat_history.append({"role": "user", "parts": [{"text": message}]})
	###
	###ask_ai()
	###user_input.text = "" # Clear input field
###
#### --- Send query to Gemini with full history ---
###func ask_ai():
	###var headers = ["Content-Type: application/json"]
	###print("AI API initiated!")
	#### Build the request body, including the system instruction and the full history
	###var body = {
		#### Add a System Instruction for persona and guidance
		###"config": {
			###"systemInstruction": "You are a friendly fitness assistant named 'InfiniCoach'. Motivate and guide the user in their fitness journey with short, practical, and encouraging advice. Keep your responses concise and engaging."
		###},
		###"contents": chat_history # Send all past messages for context
	###}
###
	###var body_json = JSON.stringify(body)
	###http.request(GEMINI_URL, headers, HTTPClient.METHOD_POST, body_json) # Removed the redundant 'true' argument
###
#### --- Handle Gemini’s reply ---
###func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	###var body_string = body.get_string_from_utf8()
	###var data = JSON.parse_string(body_string) # Clean Godot 4 parsing
###
	###print(data)
###
	###if response_code == 200 and data is Dictionary:
		###if data.has("candidates") and data["candidates"].size() > 0:
			###var gemini_message = data["candidates"][0]["content"]["parts"][0]["text"]
			###
			#### 1. Add AI message to UI
			###_add_message("AI Coach", gemini_message, Color(0.1, 0.8, 0.3))
			###
			#### 2. Add AI message to history (for future context)
			###chat_history.append({"role": "model", "parts": [{"text": gemini_message}]})
			###
		###elif data.has("error"):
			#### Handle API specific errors (e.g., blocked content, invalid key)
			###var error_msg = str(data["error"]["message"])
			###_add_message("AI Coach", "System Error: Check API Key or content filters. Details: " + error_msg, Color(0.8, 0.1, 0.1))
		###else:
			###_add_message("AI Coach", "Sorry, InfiniCoach couldn't generate a response 😅", Color(0.8, 0.1, 0.1))
	###else:
		#### Handle network or parsing failure
		###push_error("Request failed with code: " + str(response_code) + " Body: " + body_string)
		###_add_message("AI Coach", "Network connection or server failed (Code: " + str(response_code) + ").", Color(0.8, 0.1, 0.1))
###
###
#### --- Helper: Add messages to the chatbox ---
###func _add_message(sender: String, text: String, color: Color):
	###var rlbl = RichTextLabel.new()
	###rlbl.bbcode_enabled = true
	###rlbl.push_color(color)
	###rlbl.add_text(sender + ": " + text + "\n")
	###rlbl.pop()
	###
	#### Style and size flags for chat bubbles
	###rlbl.fit_content = true 
	###rlbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	###
	###chat_box.add_child(rlbl)
###
	#### Scroll to the bottom to view the latest message
	#### Must wait a frame for the layout to update before scrolling
	###await get_tree().process_frame
	###if $ScrollContainer.get_v_scroll_bar():
		###$ScrollContainer.get_v_scroll_bar().value = $ScrollContainer.get_v_scroll_bar().max_value
##
##extends Control
##
### --- Node References ---
##@onready var http = $HTTPRequest 
##@onready var chat_box = $ScrollContainer/ChatBox # The VBoxContainer inside ScrollContainer
##@onready var user_input = $UserInput
##@onready var send_button = $SendButton
##
### --- API Configuration ---
### 🚨 SECURITY WARNING: Replace with your actual key. 
##var GEMINI_API_KEY = "AIzaSyANq4FmN31r9216WXNn9cm9vVbOaAsZdXg" 
##var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY
##
### 🚨 CRITICAL: This array stores the full conversation history for context.
##var chat_history: Array = [] 
##
### --- Initialization ---
##func _ready():
	### Connect signals using the modern Godot 4 Callable syntax
	##send_button.pressed.connect(Callable(self, "_on_send_pressed"))
	##user_input.text_submitted.connect(Callable(self, "_on_send_pressed")) 
	##http.request_completed.connect(Callable(self, "_on_HTTPRequest_request_completed"))
##
### --- User Input Handlers ---
##func _on_send_pressed():
	##var message = user_input.text.strip_edges()
	##if message.is_empty():
		##return
		##
	### 1. Add user message to UI
	##_add_message("You", message, Color(0.2, 0.6, 1))
	##
	### 2. Add message to the history for the API payload
	##chat_history.append({"role": "user", "parts": [{"text": message}]})
	##
	##ask_ai()
	##user_input.text = "" # Clear input field
##
### --- Send query to Gemini with full history ---
##func ask_ai():
	##printt("API Initiadted")
	##var headers = ["Content-Type: application/json"]
##
	### 🚨 FIX APPLIED HERE: systemInstruction moved to the top level 
	##var body = {
		### ✅ CORRECT: systemInstruction is a direct field in the request body
		##"systemInstruction": "You are a friendly fitness assistant named 'InfiniCoach'. Motivate and guide the user in their fitness journey with short, practical, and encouraging advice. Keep your responses concise and engaging.",
		##
		##"contents": chat_history # Send all past messages for context
	##}
##
	##var body_json = JSON.stringify(body)
	##http.request(GEMINI_URL, headers, HTTPClient.METHOD_POST, body_json) 
##
### --- Handle Gemini’s reply ---
##func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	##var body_string = body.get_string_from_utf8()
	##var data = JSON.parse_string(body_string)
	##print(data)
	##if response_code == 200 and data is Dictionary:
		##if data.has("candidates") and data["candidates"].size() > 0:
			##var gemini_message = data["candidates"][0]["content"]["parts"][0]["text"]
			##
			### 1. Add AI message to UI
			##_add_message("AI Coach", gemini_message, Color(0.1, 0.8, 0.3))
			##
			### 2. Add AI message to history
			##chat_history.append({"role": "model", "parts": [{"text": gemini_message}]})
			##
		##elif data.has("error"):
			### Handle API specific errors
			##var error_msg = str(data["error"]["message"])
			##_add_message("AI Coach", "System Error: Check API Key or content filters. Details: " + error_msg, Color(0.8, 0.1, 0.1))
		##else:
			##_add_message("AI Coach", "Sorry, InfiniCoach couldn't generate a response 😅", Color(0.8, 0.1, 0.1))
	##else:
		##push_error("Request failed with code: " + str(response_code) + " Body: " + body_string)
		##_add_message("AI Coach", "Network connection or server failed (Code: " + str(response_code) + ").", Color(0.8, 0.1, 0.1))
##
##
### --- Helper: Add messages to the chatbox and handle scrolling ---
##func _add_message(sender: String, text: String, color: Color):
	##var rlbl = RichTextLabel.new()
	##rlbl.bbcode_enabled = true
	##rlbl.push_color(color)
	##rlbl.add_text(sender + ": " + text + "\n")
	##rlbl.pop()
	##
	### Set sizing flags for dynamic chat bubbles
	##rlbl.fit_content = true 
	##rlbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	##
	##chat_box.add_child(rlbl)
##
	### 🚨 SCROLL FIX APPLIED HERE: Scrolls to the bottom in Godot 4 🚨
	### 1. Wait a frame for the layout engine to calculate the new content size.
	##await get_tree().process_frame
	##
	### 2. Use the correct function: get_v_scroll_bar()
	##var v_scrollbar = $ScrollContainer.get_v_scroll_bar()
	##
	### 3. Set the scroll position to the maximum value.
	##v_scrollbar.value = v_scrollbar.max_value
	#
#extends Control
#
## --- Node References ---
#@onready var http = $HTTPRequest 
#@onready var chat_box = $ScrollContainer/ChatBox # This should be the VBoxContainer inside the ScrollContainer
#@onready var user_input = $UserInput
#@onready var send_button = $SendButton
#
## --- API Configuration ---
## 🚨 SECURITY WARNING: Replace with your actual key. 
#var GEMINI_API_KEY = "AIzaSyANq4FmN31r9216WXNn9cm9vVbOaAsZdXg" 
#var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY
#
## 🚨 CRITICAL: This array stores the full conversation history for multi-turn chat.
#var chat_history: Array = [] 
#
## --- Initialization ---
#func _ready():
	## Connect signals using the modern Godot 4 Callable syntax
	#send_button.pressed.connect(Callable(self, "_on_send_pressed"))
	#user_input.text_submitted.connect(Callable(self, "_on_send_pressed")) 
	#http.request_completed.connect(Callable(self, "_on_HTTPRequest_request_completed"))
#
## --- User Input Handlers ---
#func _on_send_pressed():
	#var message = user_input.text.strip_edges()
	#if message.is_empty():
		#return
		#
	## 1. Add user message to UI
	#_add_message("You", message, Color(0.2, 0.6, 1))
	#
	## 2. Add user message to the history 
	#chat_history.append({"role": "user", "parts": [{"text": message}]})
	#
	#ask_ai()
	#user_input.text = "" # Clear input field
#
## --- Send query to Gemini with full history ---
#func ask_ai():
	#print("API ki MA")
	#var headers = ["Content-Type: application/json"]
#
	## Define the System Instruction content block
	## 🚨 FIX: Using role: "system" is the reliable way to pass system instructions via REST API 
	## when the dedicated top-level field fails schema validation.
	#var system_instruction_content = {
		#"role": "system",
		#"parts": [{"text": "You are a friendly fitness assistant named 'InfiniCoach'. Motivate and guide the user in their fitness journey with short, practical, and encouraging advice. Keep your responses concise and engaging."}]
	#}
	#
	## Prepend the system instruction to the conversation contents for the API call
	#var contents_with_system = [system_instruction_content] + chat_history
	#
	## Build the request body without the problematic 'systemInstruction' field
	#var body = {
		#"contents": contents_with_system # Send the array including the system message and history
	#}
#
	#var body_json = JSON.stringify(body)
	#http.request(GEMINI_URL, headers, HTTPClient.METHOD_POST, body_json) 
#
## --- Handle Gemini’s reply ---
#func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	#var body_string = body.get_string_from_utf8()
	#var data = JSON.parse_string(body_string) # Godot 4 JSON parsing
	#print(data)
	#if response_code == 200 and data is Dictionary:
		#if data.has("candidates") and data["candidates"].size() > 0:
			#var gemini_message = data["candidates"][0]["content"]["parts"][0]["text"]
			#
			## 1. Add AI message to UI
			#_add_message("AI Coach", gemini_message, Color(0.1, 0.8, 0.3))
			#
			## 2. Add AI message to history (role: "model")
			#chat_history.append({"role": "model", "parts": [{"text": gemini_message}]})
			#
		#elif data.has("error"):
			#var error_msg = str(data["error"]["message"])
			#_add_message("AI Coach", "System Error: Check API Key or content filters. Details: " + error_msg, Color(0.8, 0.1, 0.1))
		#else:
			#_add_message("AI Coach", "Sorry, InfiniCoach couldn't generate a response 😅", Color(0.8, 0.1, 0.1))
	#else:
		#push_error("Request failed with code: " + str(response_code) + " Body: " + body_string)
		#_add_message("AI Coach", "Network connection or server failed (Code: " + str(response_code) + ").", Color(0.8, 0.1, 0.1))
#
#
## --- Helper: Add messages to the chatbox and handle scrolling ---
#func _add_message(sender: String, text: String, color: Color):
	#var rlbl = RichTextLabel.new()
	#rlbl.bbcode_enabled = true
	#rlbl.push_color(color)
	#rlbl.add_text(sender + ": " + text + "\n")
	#rlbl.pop()
	#
	#rlbl.fit_content = true 
	#rlbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	#
	#chat_box.add_child(rlbl)
#
	## 🚨 SCROLL FIX APPLIED: Correct Godot 4 scrolling after waiting a frame 🚨
	#await get_tree().process_frame
	#
	#var v_scrollbar = $ScrollContainer.get_v_scroll_bar()
	#v_scrollbar.value = v_scrollbar.max_value
#
#
##This script should now handle the conversation flow, maintain history, and correctly interface with the Gemini API without throwing any of the previous Godot-specific errors! Let me know if you have any questions about integrating this script into your scene hierarchy.
extends Control

# --- Node References ---
@onready var http = $HTTPRequest 
@onready var chat_box = $ScrollContainer/ChatBox 
@onready var user_input = $UserInput
@onready var send_button = $SendButton

# --- API Configuration ---
var GEMINI_API_KEY = "AIzaSyANq4FmN31r9216WXNn9cm9vVbOaAsZdXg" # 🚨 RENAME THIS LINE
var GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY

# CRITICAL: Stores the full conversation history for multi-turn chat.
var chat_history: Array = [] 

# --- Initialization ---
func _ready():
	send_button.pressed.connect(Callable(self, "_on_send_pressed"))
	user_input.text_submitted.connect(Callable(self, "_on_send_pressed")) 
	http.request_completed.connect(Callable(self, "_on_HTTPRequest_request_completed"))
	print("InfiniHealth Chat Initialized.")

# --- User Input Handlers ---
func _on_send_pressed():
	var message = user_input.text.strip_edges()
	$RichTextLabel.text += '\n \n' + "You: " + message
	if message.is_empty():
		return
		
	# 1. Add user message to UI
	_add_message("You", message, Color(0.2, 0.6, 1))
	
	# 2. Add user message to the history 
	chat_history.append({"role": "user", "parts": [{"text": message}]})
	
	ask_ai()
	user_input.text = "" # Clear input field

# --- Send query to Gemini with full history and Pre-Prompting ---
func ask_ai():
	print("API Initiated: Sending message to Gemini...")

	var headers = ["Content-Type: application/json"]
	
	# --- Implementing Pre-Prompting ---
	# We use this hack because the API strictly enforces only "user" and "model" roles.
	
	# Create a copy of the history to modify for the request
	var contents_for_api = chat_history.duplicate(true) 
	
	# Prepending the System Instruction to the FIRST user message's text
	if contents_for_api.size() >= 1 and contents_for_api[0]["role"] == "user":
		var instruction = "You are a friendly fitness assistant named 'InfiniCoach'. Motivate and guide the user in their fitness journey with short, practical, and encouraging advice. Keep your responses concise and engaging. Your response must only be the advice, nothing else. The current conversation follows.\n\n"
		
		# Prepend the instruction to the text part of the first user message
		contents_for_api[0]["parts"][0]["text"] = instruction + contents_for_api[0]["parts"][0]["text"]


	# Build the request body 
	var body = {
		"contents": contents_for_api 
	}

	var body_json = JSON.stringify(body)
	http.request(GEMINI_URL, headers, HTTPClient.METHOD_POST, body_json) 

# --- Handle Gemini’s reply ---
func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	var body_string = body.get_string_from_utf8()
	var data = JSON.parse_string(body_string) # Godot 4 JSON parsing

	print("API Request Completed. HTTP Code: " + str(response_code))
	print(data)
	
	$RichTextLabel.text += '\n \n' + "AI: " + data['candidates'][0]['content']['parts'][0]['text']
	
	if response_code == 200 and data is Dictionary:
		if data.has("candidates") and data["candidates"].size() > 0:
			var gemini_message = data["candidates"][0]["content"]["parts"][0]["text"]
			
			# 1. Add AI message to UI
			_add_message("AI Coach", gemini_message, Color(0.1, 0.8, 0.3))
			
			# 2. Add AI message to history (role: "model")
			chat_history.append({"role": "model", "parts": [{"text": gemini_message}]})
			print("Success: Message received and chat history updated.")
			
		elif data.has("error"):
			# Handle API specific errors (e.g., content filters)
			var error_msg = str(data["error"]["message"])
			_add_message("AI Coach", "System Error: Check API Key or content filters. Details: " + error_msg, Color(0.8, 0.1, 0.1))
			print("Error: Gemini returned a content error or invalid request: " + body_string)
		else:
			_add_message("AI Coach", "Sorry, InfiniCoach couldn't generate a response 😅", Color(0.8, 0.1, 0.1))
	else:
		# Handle network or parsing failure
		push_error("Request failed with code: " + str(response_code) + " Body: " + body_string)
		_add_message("AI Coach", "Network connection or server failed (Code: " + str(response_code) + ").", Color(0.8, 0.1, 0.1))
		print("Fatal Error: Network or unknown API failure. Raw Body: " + body_string)
		print(data)

# --- Helper: Add messages to the chatbox and handle scrolling ---
func _add_message(sender: String, text: String, color: Color):
	var rlbl = RichTextLabel.new()
	rlbl.bbcode_enabled = true
	rlbl.push_color(color)
	rlbl.add_text(sender + ": " + text + "\n")
	rlbl.pop()
	
	rlbl.fit_content = true 
	rlbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	
	chat_box.add_child(rlbl)

	# Correct Godot 4 scrolling after waiting a frame
	await get_tree().process_frame
	
	var v_scrollbar = $ScrollContainer.get_v_scroll_bar()
	v_scrollbar.value = v_scrollbar.max_value
