# Hooked on Words

**Hooked on Words** is a fast-paced, arcade-style typing game built using Processing. Beyond the core typing mechanics, it features a poignant narrative frame: players step into the fading mind of an old man on his deathbed. Choosing to spend his final moments remembering his youth, his lifelong passion for fishing becomes a psychological battle to hold onto his dearest memories. The faster and more accurately you type, the better your chances of landing a prize catch and keeping his memories alive!

---

## The Narrative Frame

The entire game takes place within the old man's final, nostalgic reverie:
* **The Deathbed Monologue (Intro):** Before the main title screen appears, the game opens in absolute darkness. A monologue fades in, capturing the old man's shallow breaths in a hospital room as he makes a conscious choice to drift back to the calm, crisp mornings of his youth.
* **The Memory Bubble:** Once the dream begins and gameplay takes over, a continuous "thought bubble" sits at the top of the screen. This bubble dynamically reveals his internal monologue—reflecting on his grandfather's lessons, the smell of the old lake, or how strong his hands used to be compared to the fading strength of his present body.

---

## Game Modes

You can switch modes directly from the Title Screen using the interactive selection button:

### 1. Normal Mode
The classic experience. When a fish is hooked, a pre-set sentence matching the fish's difficulty appears. Typing each character correctly reels the fish closer step-by-step, while typos cause the fish to thrash and pull away.

### 2. Free Type Mode
A flexible, custom typing experience. Instead of following a prompt, players can type absolutely **anything** they want into a free-text field. Pressing `ENTER` executes a dynamic pull, where the reel strength is calculated entirely by the length of the phrase typed (longer words exert a stronger mechanical pull on the line).

---

## How to Play

The main game loop is run directly from `Hooked_on_Words.pde`, which acts as the core of the application. The game handles transitions through the following stages:

1. **The Deathbed Intro:** Press `SPACEBAR` to progress through the old man's opening monologue.
2. **The Boat (Title Screen):** Customize your experience here. Switch between **Normal** and **Free Type** modes, or open the custom sentence panel. Press `SPACEBAR` to cast your line into the dream and begin.
3. **Waiting for a Bite:** Relax and wait. A fish will randomly bite within a few seconds, while the old man muses over his steady hands from fifty years ago.
4. **The Bite (Fishing Phase):** When a fish strikes, its silhouette appears underwater with an input bubble. Type the exact name of the fish and press `ENTER` to hook it. If you mistype or wait too long, the fish gets away, causing his focus to drift and costing you a life!
5. **The Fight (Reeling Phase):** Once hooked, the real battle begins! 
   * **In Normal Mode:** Type the target sentence accurately to reel it in.
   * **In Free Type Mode:** Write any phrase you want and hit `ENTER` to pull the fish in based on word length.
   * *Note: You can click the red **'X' button** in the top-right corner at any point during active gameplay to completely reset your metrics (score and lives) and safely exit to the title screen.*
6. **The Fading Memory (Game Over):** Lose all 3 lives, and the old man's consciousness fades entirely. Press `SPACEBAR` to remember again, resetting your score to restart the dream.

---

## Code Architecture

The game's inner workings are split across a few key files to keep everything organized:
* `Hooked_on_Words.pde`: The central window that loads the graphics, animation framerates, sets up window properties, and maps system key/mouse triggers.
* `GameManager.pde`: The brain of the operation. It tracks game states, score, lives, handles UI layouts for the title buttons, processes the exit button, and manages narrative context shifts.
* `Fish.pde`: Governs the individual fish types. It handles what they look like, how many points they are worth, and how aggressively they pull away from you during a struggle.
* `TypingEngine.pde`: The text processing engine. It keeps track of character indexes, holds user phrases inside dynamic `StringList` arrays, and processes custom text submissions.

---

## Custom Sentence Customization

Players can add their own custom sentences to expand the vocabulary pools. Clicking the **"Add Custom Sentences"** button on the Title Screen opens a dedicated configuration board:
* Choose the difficulty target pool (**Easy**, **Medium**, or **Hard**) by clicking the respective tab toggles.
* Type out your personalized text phrase directly into the field box.
* Press `ENTER` to permanently append it to that difficulty pool and return to the Title Screen, or press `ESCAPE` to cancel your changes.

---

## Fish Species & Difficulty

Different fish evoke different levels of recollection. Harder fish are worth more points but will struggle more violently against your line. Their dynamic narrative thoughts vary below:

| Fish Species | Difficulty | Points | Fight Level | Old Man's Narrative Impression |
| :--- | :--- | :--- | :--- | :--- |
| **Bass** | Easy | 10 pts | Low | *"Feels like a small one. A nice easy catch to start the morning."* |
| **Trout** | Medium | 25 pts | Moderate | *"Ah, it's got some weight to it! Don't lose it now."* |
| **Snapper** | Medium | 25 pts | Moderate | *"Ah, it's got some weight to it! Don't lose it now."* |
| **Salmon** | Hard | 50 pts | Heavy | *"Good heavens, this pull... it's a monster! Just like the one that got away in '74!"* |
| **Tuna** | Hard | 50 pts | Heavy | *"Good heavens, this pull... it's a monster! Just like the one that got away in '74!"* |

---

## Game Controls

* **`Letters (A-Z) / Space`**: Type characters on screen to answer prompts, input fish names, or build words.
* **`BACKSPACE`**: Delete typos or edit text inside input fields.
* **`ENTER / RETURN`**: Submit fish names, execute free-type line pulls, or save text edits.
* **`SPACEBAR`**: Progress through the deathbed monologue, launch the fishing dream, or reset after a Game Over.
* **`ESCAPE`**: Exit the Custom Sentence panel without saving.
* **`Mouse Click`**: Toggle game modes, select difficulty pools, or press the top-right **'X'** button to exit a match and reset stats.

---

## Game Assets Setup

To run this game, make sure your project has a folder named `data/` containing the following animation and image files:

* `ocean.gif` (The moving water background)
* `background.png` (The scenery background image)
* `fisher_1.png` to `fisher_4.png` (The old man's younger self-animation frames)
* `bass.png`
* `trout.png`
* `snapper.png`
* `salmon.png`
* `tuna.png`
* `bgm.mp3` / `hook.mp3` / `lose.mp3` / `over.mp3` (Audio configuration clips)

---

## Team Members

* **[Joshua Putra Pratama/F11415027]**
* **[Lucas Metzger/F11415020]**
* **[Pei Chen, Lin/B11110113]**