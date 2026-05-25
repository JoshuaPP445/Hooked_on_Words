# Hooked on Words

A fast-paced, arcade-style typing game built with Processing (Java). Players take on the role of a fisherman trying to reel in different fish species by typing dynamically generated sentences. Each fish features distinct artwork, difficulty levels, and scoring values.

## Game Mechanics & Phases

The game cycles through four main states managed by a state engine:

1. **Start Screen (State 3):** Displays the game title. Press `SPACE` to start.
2. **Waiting Phase (State 4 / WAITING):** The fisherman waits for a random period (1 to 3 seconds) for a fish to bite.
3. **Fishing Phase (State 0):** A fish bites! An underwater silhouette of the specific fish appears alongside a text bubble. Type the name of the fish and press `ENTER` to hook it. Missing the target or taking too long results in a lost life.
4. **Reeling Phase (State 1):** The fish is hooked! The line physically attaches to the mouth of the fish image. You must accurately type sentences that pull from custom pools based on that fish's difficulty tier:
   * **Correct characters:** Pull the fish closer to the pier (`hookX` decreases).
   * **Incorrect characters / Fish struggle:** The fish fights back and pulls away (`hookX` increases).
5. **Game Over (State 2):** Triggered when lives reach 0. Displays your final score. Press `SPACE` to reset and try again.

---

## Dynamic Difficulty & Scoring System

Fish are categorized into three explicit difficulty tiers (`easy`, `medium`, and `hard`). The difficulty determines how aggressively the fish struggles, the length/complexity of the sentences generated, and the point reward upon a successful catch.

| Fish Species | Difficulty Tier | Point Value | Struggle Factor |
| :--- | :--- | :--- | :--- |
| **Bass** | Easy | 5 pts | 0.4 (Low struggle) |
| **Mackerel** | Medium | 15 pts | 0.9 (Moderate struggle) |
| **Snapper** | Medium | 15 pts | 0.9 (Moderate struggle) |
| **Trout** | Hard | 40 pts | 1.4 (Heavy struggle) |
| **Tuna** | Hard | 40 pts | 1.4 (Heavy struggle) |

### Sentences Pools By Difficulty
* **Easy:** Short, introductory phrasing (*"Easy does it"*, *"Hold the line"*, *"Fish on"*)
* **Medium:** Longer action phrases (*"Keep reeling it in"*, *"Dont let it get away"*, *"Pull it closer"*)
* **Hard:** Longer, complex descriptions (*"The ocean is deep and blue"*, *"Fighting a monster of the deep"*, *"Hold on for dear life"*)

---

## Technical Features

* **Matrix Transformations:** Leverages `pushMatrix()`, `popMatrix()`, `translate()`, `rotate()`, and `scale()` to manipulate 48x48 pixel PNG assets—applying a precise 45-degree rotation and a vertical flip to render sprites correctly.
* **Pixel-Perfect Boundary Physics:** Game victory and failure thresholds during the reeling phase evaluate the line connection offset point (`hookX`) rather than the asset's center point (`fishX`). The fish escapes if `hookX >= 750` and is successfully caught when `hookX <= 150`.
* **Visual Effects:** Utilizes a custom color tint overlay (`tint(0, 50, 120, 100)`) to project an underwater silhouette preview of the specific fish model during the initial bite phase.

---

## Assets Setup

To successfully run this sketch, ensure your root project contains a folder named `data/` with the following 48x48 pixel image files:
* `bass.png`
* `mackerel.png`
* `snapper.png`
* `trout.png`
* `tuna.png`

## Controls
* **`A-Z / Keys`**: Type letters corresponding to targets or sentences.
* **`BACKSPACE`**: Delete character inputs inside the fish bite text bubble.
* **`ENTER / RETURN`**: Submit your text string in the fishing bite phase.
* **`SPACEBAR`**: Progress past the start screen or restart from a game-over screen.