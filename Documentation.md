# InfiniHealth Application

This document outlines the user engagement flow of the InfiniHealth Godot application, based on an analysis of its scene (`.tscn`) and script (`.gd`) files.

## 1. Application Entry Point

- **File:** `project.godot`
- **Main Scene:** `res://control.tscn`

The application's entry point is the `control.tscn` scene. This scene acts as a splash screen.

### Splash Screen (`control.tscn`)

- **Script:** `main_screen.gd`
- **Functionality:**
    1.  Displays the splash screen image (`splash.png`).
    2.  A timer runs for 2 seconds.
    3.  After the timeout, the application automatically transitions to the main application screen (`res://main.tscn`).

## 2. Main Screen (`main.tscn`)

This is the central hub of the application.

- **UI Components:**
    - A text input field prompting "What is on your mind today?".
    - A "Steps" panel that displays the user's step count (e.g., "10,350 Steps").
    - A "Hydration" button.
    - A "Diet Plan" button.
    - Navigation buttons: "Home" and "Profile".

- **Interactions:**

    - **Hydration Button:**
        - **Script:** `water_screen.gd`
        - **Action:** When pressed, it transitions the user to the Water Tracking Screen (`res://water_screen.tscn`).

    - **Profile Button:**
        - **Script:** `profile_button.gd`
        - **Action:** When pressed, it transitions the user to the Profile Screen (`res://Profile.tscn`).

    - **Home Button:**
        - **Script:** `home_button.gd`
        - **Action:** Returns the user to this Main Screen (`res://main.tscn`). This is useful for navigating back from other screens.

    - **Steps Counter:**
        - **Script:** `change_steps.gd`
        - **Functionality:** A timer is set to increment the step count, simulating real-time step tracking.

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
        - **Action:** When pressed, it increases the value of the progress bar. A tween is used to animate the progress bar's value change smoothly.

    - **Navigation (Home/Profile):**
        - The "Home" and "Profile" buttons function identically to the main screen, allowing the user to navigate to the respective scenes.

## 4. Profile Screen (`Profile.tscn`)

This screen displays the user's profile information and progress.

- **UI Components:**
    - A profile picture area.
    - A label for the user's name.
    - A "Progress" section with three progress bars:
        - "Xp"
        - "Todays Progress"
        - "WinSteak"
    - A "Personal Details" section.
    - A "Home" navigation button.

- **Interactions:**

    - **Home Button:**
        - **Script:** `home_button.gd`
        - **Action:** Navigates the user back to the Main Screen (`res://main.tscn`).

## Summary of Navigation Flow

1.  **App Start** -> `control.tscn` (Splash Screen)
2.  **(2s delay)** -> `main.tscn` (Main Screen)
3.  **From `main.tscn`:**
    - Click "Hydration" -> `water_screen.tscn`
    - Click "Profile" -> `Profile.tscn`
4.  **From `water_screen.tscn`:**
    - Click "Home" -> `main.tscn`
    - Click "Profile" -> `Profile.tscn`
5.  **From `Profile.tscn`:**
    - Click "Home" -> `main.tscn`
