# InfiniHealth Application: User Engagement Flow

This document outlines the complete user engagement flow of the InfiniHealth Godot application, including the newly integrated AI features.

---

## 1. Application Entry Point

- **File:** `project.godot`
- **Main Scene:** `res://control.tscn`

### Splash Screen (`control.tscn`)

- **Script:** `main_screen.gd`
- **Functionality:**
    1. Displays the splash screen image (`splash.png`).
    2. A timer runs for 2 seconds.
    3. After the timeout, the application automatically transitions to the main application screen (`res://main.tscn`).

---

## 2. Main Screen (`main.tscn`) 🧠

This is the central hub of the application, now featuring the AI-powered fitness coach.

- **UI Components:**
    - **InfiniCoach Chat Input:** A text input field prompting "What is on your mind today?". This field initiates the AI conversation.
    - A "Steps" panel that displays the user's step count (e.g., "10,350 Steps").
    - A "Hydration" button.
    - A "Diet Plan" button.
    - Navigation buttons: "Home" and "Profile".

- **Interactions:**

    - **AI Chat Input:**
        - **Script:** The chat logic is contained within the `main.tscn`'s controller script (or a child script attached to the UI elements).
        - **Action:** When the user enters text, the message is sent to the Gemini API, and the response from the **InfiniCoach** is displayed back to the user in a chat window, maintaining full conversation history.
        - **AI Persona:** The AI is pre-prompted to act as a friendly fitness assistant, providing concise, motivational advice.

    - **Hydration Button:**
        - **Script:** `water_screen.gd`
        - **Action:** When pressed, it transitions the user to the Water Tracking Screen (`res://water_screen.tscn`).

    - **Profile Button:**
        - **Script:** `profile_button.gd`
        - **Action:** When pressed, it transitions the user to the Profile Screen (`res://Profile.tscn`).

    - **Steps Counter:**
        - **Script:** `change_steps.gd`
        - **Functionality:** A timer is set to increment the step count, simulating real-time step tracking.

---

## 3. Water Tracking Screen (`water_screen.tscn`)

This screen is dedicated to tracking the user's water intake.

- **UI Components:**
    - A large image of a water glass (`water_glass.png`).
    - A button labeled "I have drunk water!".
    - A progress bar to visualize daily water intake.
    - "Home" and "Profile" navigation buttons.

- **Interactions:**

    - **"I have drunk water!" Button:**
        - **Script:** `water_button.gd`
        - **Action:** When pressed, it **increments the Progress Bar** value (tracking a key KPI) and uses a **Tween** for smooth animation.

    - **Navigation (Home/Profile):**
        - The "Home" and "Profile" buttons function identically to the main screen, allowing the user to navigate to the respective scenes.

---

## 4. Profile Screen (`Profile.tscn`) ⭐

This screen displays the user's profile information and progress, showcasing gamification elements.

- **UI Components:**
    - A profile picture area.
    - A label for the user's name.
    - A **"Progress" section** with three progress bars:
        - **"Xp"** (Experience Points)
        - **"Todays Progress"** (Daily Goal Completion)
        - **"WinSteak"** (Consecutive days of goal achievement)
    - A "Personal Details" section.
    - A "Home" navigation button.

- **Interactions:**

    - **Home Button:**
        - **Script:** `home_button.gd`
        - **Action:** Navigates the user back to the Main Screen (`res://main.tscn`).

---

## Summary of Navigation Flow

1.  **App Start** -> `control.tscn` (Splash Screen)
2.  **(2s delay)** -> `main.tscn` (Main Screen)
3.  **From `main.tscn`:**
    - User input in Chat Field -> **AI Chat Interaction (InfiniCoach)**
    - Click "Hydration" -> `water_screen.tscn`
    - Click "Profile" -> `Profile.tscn`
4.  **From `water_screen.tscn`:**
    - Click "I have drunk water!" -> **Updates KPI (Progress Bar)**
    - Click "Home" -> `main.tscn`
    - Click "Profile" -> `Profile.tscn`
5.  **From `Profile.tscn`:**
    - Click "Home" -> `main.tscn`

---
You can learn more about building intelligent chat functionality in the Godot engine by watching [AI Chat Bot in a Godot game with Ollama: a tutorial (local LLM)](https://www.youtube.com/watch?v=5alwh-DdPI0).
http://googleusercontent.com/youtube_content/1
