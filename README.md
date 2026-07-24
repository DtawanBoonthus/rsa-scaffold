# rsa-scaffold

**English** | [ไทย](README.th.md)

Generate the **Reactive-Simulation Architecture (RSA)** folder structure for a Unity project with a single command — no more creating folders one by one when starting a new project.

---

## What is RSA

A Unity game architecture built on **Layered + MVVM + Mediator (VitalRouter)**, splitting code by **two execution models**:

| Side | How it runs | Lives in |
|---|---|---|
| **Reactive** (UI, menus, score) | waits for input, then responds | `Presentation/`, `Domain/` |
| **Simulation** (enemies, bullets, characters) | runs every frame on its own | `Actors/`, `ECS/` |

The two sides never call each other directly — they talk through a single **Mediator (VitalRouter)**. Crossing from ECS to the managed side goes through a **Bridge** (`SystemBase`). `Network/` is a removable module (offline-first).

---

## Usage

```bash
# macOS / Linux / Git Bash
bash rsa-scaffold.sh base       # full offline structure
bash rsa-scaffold.sh online     # base + Network module (multiplayer)
```

```powershell
# Windows PowerShell
./rsa-scaffold.ps1 base
./rsa-scaffold.ps1 online
```

Run it from the Unity project root (the folder containing `Assets/`). Everything is created under `Assets/_Project/`.

> A `.gitkeep` is placed in every folder so empty folders can be committed. Safe to re-run (idempotent) — it never overwrites existing files.

---

## Run straight from the command line (nothing to download)

**macOS / Linux / Git Bash:**
```bash
curl -fsSL https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.sh | bash -s -- online
```

**Windows PowerShell:**
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.ps1))) online
```

Both URLs point at the `v1.0` tag, so the script you run today is exactly the script you get next month. To move to a newer version, replace `v1.0` with a later tag from the [releases](https://github.com/DtawanBoonthus/rsa-scaffold/tags).

### Install as a permanent command

```bash
mkdir -p ~/bin
curl -fsSL https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.sh -o ~/bin/rsa-scaffold
chmod +x ~/bin/rsa-scaffold
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

Then, in any project:
```bash
rsa-scaffold online
```

---

## Generated structure

```text
Assets/_Project/
├── Scripts/
│   ├── Foundation/     generic engine tools, game-agnostic (Pool, ScreenManager)
│   ├── Domain/         business logic — Pure C#, testable (Models/Services/Commands/Configs)
│   ├── Presentation/   [Reactive] MVVM UI (ViewModel + View)
│   ├── Actors/         [Simulation] MonoBehaviour gameplay, few entities (Player, Boss)
│   ├── ECS/            [Simulation] data-oriented gameplay (Enemy/Projectile + Bridges)
│   ├── Reactors/       react to events with side effects (Audio, Camera)
│   ├── Infrastructure/ talk to the outside world (Save, Audio, Input)
│   ├── Bootstrap/      DI registration + wiring
│   └── Network/        removable online module (online only) — Session/Bridges/Entities/Protocol/Transport
├── Settings/           Rendering / Volumes (URP)
├── Data/               ScriptableObject instances (.asset)
├── Prefabs/            UI / Entities / Characters
├── Art/                Sprites / Fonts
├── Audio/              BGM / SFX
└── Scenes/             + SubScenes/ (ECS bake target)
```

| Action | Creates |
|---|---|
| `base` | full offline structure (no `Network/`) |
| `online` | `base` + the `Network/` module for multiplayer |

---

## RSA core rules

1. `Domain/` is Pure C# — never reference `UnityEngine.UI` / `Unity.Entities`
2. `ECS/` has its own asmdef with no R3/VitalRouter/UI → Burst-safe
3. Crossing ECS → managed must go through `ECS/Bridges/` (asmdef `_Project.ECS.Bridges`) only
4. `interface` lives in `Domain/`; engine-bound implementations live in `Infrastructure/` or `Network/`
5. `using FishNet` (or any networking lib) is allowed only inside `Network/`; nothing depends back on `Network/` → it stays removable
6. Code (`.cs`) is separated from assets (`.asset` / prefab / `.uxml`)

> This tool creates folders only — add the `.asmdef` files yourself per the rules above.
