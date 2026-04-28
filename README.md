<div align="center">

# 🐍 PyQuest

### *Learn Python Through Gamification*

![Made with Godot](https://img.shields.io/badge/Made%20with-Godot%204-478CBF?style=flat&logo=godotengine&logoColor=white)
![Language](https://img.shields.io/badge/Language-GdScript-3776AB?style=flat&logo=godotengine&logoColor=white)
![Backend](https://img.shields.io/badge/Backend-FastAPI-009688?style=flat&logo=fastapi&logoColor=white)
![Multiplayer](https://img.shields.io/badge/Multiplayer-UDP%20%2F%20LAN-orange?style=flat)
![License](https://img.shields.io/badge/Project-Thesis-dd8f61?style=flat)

<br/>

> A 2D platformer game where every level teaches you a Python concept.  
> Fight enemies, clear stages, and level up your programming skills — for real.

</div>

---

[![Download PyQuest](https://img.shields.io/badge/Download-PyQuest%20on%20itch.io-fa5c5c?style=for-the-badge\&logo=itch.io)](https://wise394.itch.io/pyquest)

**Get PyQuest now on itch.io!**

---

## 📖 About

**PyQuest** is a thesis project that fuses game design with programming education. Instead of sitting through lectures, players learn Python by *playing through it*, each level is built around a core concept, from variables and loops to functions and data structures.

Built in **Godot Engine 4** with a **FastAPI** backend, the game evaluates player-submitted Python code server-side in real time. It also supports **local co-op multiplayer over LAN via UDP**, letting multiple players share the same world and coding session simultaneously.

---

## 🧠 How It Works
01 — Pick a Level
Each level focuses on one Python concept:
variables, loops, functions, data structures, and more.

02 — Play Through It
Fight enemies and solve in-game challenges built around that concept.
A built-in code editor lets you write and submit Python directly in-game.

03 — Code Gets Evaluated
Your submission is sent to the FastAPI backend, executed in a Python
sandbox, and validated against test cases — all in real time.

04 — Level Up
Pass all test cases to unlock the next concept
and watch your Python skills grow.

---

## ⚙️ Technical Highlights

- **Finite State Machine (FSM)** — Player behavior and game flow are managed by a custom FSM built in GDScript. It handles state transitions (idle, running, attacking, dead, evaluating) and drives level progression and adaptive learning flow cleanly without tangled conditionals.

- **FastAPI Backend** — A RESTful API built with FastAPI handles communication between the game client and the server. It exposes endpoints for fetching level questions and submitting answers keeping the game logic and data layer cleanly separated.

- **Python Interpreter & Answer Validation** — On submission, the player's code is executed in a controlled Python subprocess sandbox and validated against per-level test cases. The result is returned as structured JSON and reflected immediately in the game world.

- **In-Game Code Editor** — Players write Python directly inside the game through a built-in code editor featuring syntax highlighting and autocomplete. Pressing `C` opens the editor mid-level, letting players solve coding challenges without leaving the game.

- **LAN Multiplayer** — Built on Godot's High-Level Networking API. One player hosts, others join via local IP. Player positions, health, and level state are synced in real time using RPCs (Remote Procedure Calls) for low-latency communication.

---

## 🎮 Gameplay

<p align="center">
  <img src="https://github.com/user-attachments/assets/46cf0397-9288-4abb-83c1-12314a28fa79" height="80">
  <br>
  <img src="https://github.com/user-attachments/assets/0a58214b-802f-4075-91a9-d0153ab710dc" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e2006e07-8346-41a0-b0e2-1e589b6121e6" height="80">
  <br>
  <img src="https://github.com/user-attachments/assets/782fcb2f-e5ef-49d3-9a05-69b7492f679f" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/c1877f88-5b64-44da-8f03-45e8fe7edf9c" height="80">
  <br>
  <img src="https://github.com/user-attachments/assets/7a76970f-292b-4c70-b29c-64e43e88d965" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/c77acaa3-2a8f-4ec4-9d49-de6160aaede3" height="80">
  <br>
  <img src="https://github.com/user-attachments/assets/b74a9b7d-a02f-4c72-bb29-8f4c22a3975c" width="500">
</p>

<p align="center">
<br>
⚠️ <strong>Note:</strong> All GIFs have been greatly compressed to fit GitHub's size limits. The graphics are reduced and <strong>do not fully reflect the in-game quality</strong>.
</p>

---

## 🎮 Game Screenshots

| ![Menu](https://github.com/user-attachments/assets/9d8a3403-94c5-45fb-907e-7ebe8e479bff) | ![Code](https://github.com/user-attachments/assets/00abc683-378b-4ba5-bfaf-b32dd72c813a) |
|---------------------------------|---------------------------------|
| ![Slime](https://github.com/user-attachments/assets/7a0ba828-6725-4eec-9595-071f97279cd3) | ![Achievement](https://github.com/user-attachments/assets/f753c50d-118d-4d3d-b5e5-45ccf718acd9) |
| ![Crab](https://github.com/user-attachments/assets/72e03c7c-f64f-4cb5-a741-d39262a7ed4a) | ![Multiplayer](https://github.com/user-attachments/assets/16393cdb-69a2-4c3e-8068-bb52ce046a4b) |

---

## 🕹️ Controls

| Key | Action |
|-----|--------|
| `A` | Move Left |
| `D` | Move Right |
| `S` | Move Down |
| `E` | Talk |
| `Spacebar` | Jump |
| `C` | Open Code Editor |
| `Left Mouse Button` | Sword Attack |

---

## 🛠️ Built With

| Tool | Purpose |
|------|---------|
| **Godot Engine 4** | Game engine |
| **GDScript** | Game logic, FSM, and networking |
| **FastAPI** | REST API backend and code evaluation |
| **Python** | Server-side code sandbox and interpreter |
| **Aseprite** | Pixel art and animation |
| **Git & GitHub** | Version control and hosting |


---

## 🎨 3rd Party Assets

### Pixel Art

**Treasure Hunters** by Pixel Frog — Primary asset pack used throughout the game.  
→ [pixelfrog-assets.itch.io/treasure-hunters](https://pixelfrog-assets.itch.io/treasure-hunters)

**Bringer of Death** by Clembod — Level 20 boss character.  
→ [clembod.itch.io/bringer-of-death-free](https://clembod.itch.io/bringer-of-death-free)

**Mecha Golem** by DarkPixel-Kronovi — Level 10 boss character.  
→ [darkpixel-kronovi.itch.io/mecha-golem-free](https://darkpixel-kronovi.itch.io/mecha-golem-free)

**Slime Sprite 32x32** by Vimlark — Enemy character asset.  
→ [vimlark.itch.io/slime-sprite-32x32](https://vimlark.itch.io/slime-sprite-32x32)

---

## 📬 Contact

Questions, feedback, or bug reports?
- 🐛 Open an [Issue](../../issues) in this repository

---

<div align="center">

*PyQuest — Learn Python Through Gamification.*

</div>
