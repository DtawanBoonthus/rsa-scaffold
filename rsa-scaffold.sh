#!/usr/bin/env bash
# rsa-scaffold.sh — generate the Reactive-Simulation Architecture (RSA) folder structure
# macOS / Linux / Git Bash (Windows)
# Usage:  bash rsa-scaffold.sh base     |     bash rsa-scaffold.sh online
set -e
BASE="Assets/_Project"
ACTION="${1:-base}"

mk() { for d in "$@"; do mkdir -p "$d" && : > "$d/.gitkeep"; done; }

add_base() {
  # --- Scripts (organized by layer) ---
  mk \
    "$BASE/Scripts/Foundation/Binding" "$BASE/Scripts/Foundation/Pool" "$BASE/Scripts/Foundation/Screens" \
    "$BASE/Scripts/Domain/Models" "$BASE/Scripts/Domain/Services" \
    "$BASE/Scripts/Domain/Commands" "$BASE/Scripts/Domain/Configs" \
    "$BASE/Scripts/Presentation/_Shared" "$BASE/Scripts/Presentation/HUD" \
    "$BASE/Scripts/Actors/Player" "$BASE/Scripts/Actors/Boss" \
    "$BASE/Scripts/ECS/_Shared/Components" "$BASE/Scripts/ECS/_Shared/Systems" \
    "$BASE/Scripts/ECS/Enemy/Components" "$BASE/Scripts/ECS/Enemy/Systems" "$BASE/Scripts/ECS/Enemy/Authoring" \
    "$BASE/Scripts/ECS/Projectile/Components" "$BASE/Scripts/ECS/Projectile/Systems" "$BASE/Scripts/ECS/Projectile/Authoring" \
    "$BASE/Scripts/ECS/Bridges" \
    "$BASE/Scripts/Reactors/Audio" "$BASE/Scripts/Reactors/Camera" \
    "$BASE/Scripts/Infrastructure/Save" "$BASE/Scripts/Infrastructure/Audio" "$BASE/Scripts/Infrastructure/Input" \
    "$BASE/Scripts/Bootstrap/EntryPoints"
  # --- Asset folders (kept out of Scripts/) ---
  mk \
    "$BASE/Settings/Rendering" "$BASE/Settings/Volumes" \
    "$BASE/Data/Items" "$BASE/Data/Enemies" "$BASE/Data/Configs" \
    "$BASE/Prefabs/UI" "$BASE/Prefabs/Entities" "$BASE/Prefabs/Characters" \
    "$BASE/Art/Sprites/UI" "$BASE/Art/Fonts" \
    "$BASE/Audio/BGM" "$BASE/Audio/SFX" \
    "$BASE/Scenes/SubScenes"
  echo "OK  base created"
}

add_online() {
  # --- Network module (removable) ---
  mk \
    "$BASE/Scripts/Network/Session" "$BASE/Scripts/Network/Bridges" \
    "$BASE/Scripts/Network/Entities" "$BASE/Scripts/Network/Protocol" \
    "$BASE/Scripts/Network/Transport" \
    "$BASE/Scripts/Network/Presentation/Lobby" "$BASE/Scripts/Network/Presentation/Chat" \
    "$BASE/Scripts/Network/Bootstrap"
  echo "OK  online (Network) added"
}

case "$ACTION" in
  base)   add_base ;;
  online) add_base; add_online ;;
  *) echo "Usage: bash rsa-scaffold.sh [base|online]"; exit 1 ;;
esac
