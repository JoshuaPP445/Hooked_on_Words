# Hooked on Words

**Hooked on Words** is a fast-paced, arcade-style typing game built using Processing. Players step into the boots of a fisherman trying to reel in different fish species by typing out words and sentences. The faster and more accurately you type, the better your chances of landing a prize catch!

---

## How to Play

The main game loop is run directly from `Hooked_on_Words.pde`, which acts as the core of the application. The game handles transitions through the following stages:

1. **The Boat (Start Screen):** Press `SPACEBAR` to cast your line and begin.
2. **Waiting for a Bite:** Relax and wait. A fish will randomly bite within a few seconds.
3. **The Bite (Fishing Phase):** When a fish strikes, its silhouette appears underwater with a text bubble. Type the exact name of the fish and press `ENTER` to hook it. If you mistype or wait too long, the fish will get away and you will lose a life!
4. **The Fight (Reeling Phase):** Once hooked, the real battle begins! Sentences will appear on the screen. 
   * **Type correctly:** You pull the fish closer to the pier.
   * **Type incorrectly / Fish struggles:** The fish fights back and swims further out to sea.
   * **Win/Loss:** If you pull the fish all the way to safety, you catch it and earn points! If it swims off the edge of the screen, it snaps your line and you lose a life.
5. **Game Over:** Lose all 3 lives, and the game ends. Press `SPACEBAR` to reset your score and try again.

---

## Code Architecture

The game's inner workings are split across a few key files to keep everything organized:
* `Hooked_on_Words.pde`: The central window that loads the graphics, sets up the window size, and keeps the game drawing smoothly.
* `GameManager.pde`: The brain of the operation. It keeps track of your score, your lives, and decides whether you are currently waiting, fishing, reeling, or looking at a Game Over screen.
* `Fish.pde`: Governs the individual fish types. It handles what they look like, how many points they are worth, and how hard they pull away from you during a struggle.
* `TypingEngine.pde`: The spelling coach. It checks your keystrokes to see if you are typing the letters correctly and displays the text bubble prompts on your screen.

---

## Fish Species & Difficulty

Different fish have different behaviors. Harder fish are worth more points but will struggle more violently against your line and require you to type longer, trickier sentences.

| Fish Species | Difficulty | Points | Fight Level | Sentence Examples |
| :--- | :--- | :--- | :--- | :--- |
| **Bass** | Easy | 5 pts | Low | *"Easy does it"*, *"Fish on"* |
| **Trout** | Medium | 15 pts | Moderate | *"Keep reeling it in"*, *"Pull it closer"* |
| **Snapper** | Medium | 15 pts | Moderate | *"Keep reeling it in"*, *"Dont let it get away"* |
| **Salmon** | Hard | 40 pts | Heavy | *"The ocean is deep and blue"*, *"Hold on for dear life"* |
| **Tuna** | Hard | 40 pts | Heavy | *"Fighting a monster of the deep"* |

---

## Game Controls

* **`Letters (A-Z)`**: Type the matching characters on screen to hook or reel in fish.
* **`BACKSPACE`**: Delete a typo while trying to type the fish's name during a bite.
* **`ENTER / RETURN`**: Submit the fish's name to hook it.
* **`SPACEBAR`**: Start the game or restart after a Game Over.

---

## Game Assets Setup

To run this game, make sure your project has a folder named `data/` containing the following animation and image files:

* `ocean.gif` (The moving water background)
* `background_1.jpg` & `background_2.png` (The scenery elements)
* `bass.png`
* `trout.png`
* `snapper.png`
* `salmon.png`
* `tuna.png`

---

## Team Members

* **[Joshua Putra Pratama/F11415027]**
* **[Lucas Metzger/F11415020]**
* **[Pei Chen, Lin/B11110113]**
