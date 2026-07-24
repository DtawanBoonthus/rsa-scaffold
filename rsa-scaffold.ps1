# rsa-scaffold.ps1 — generate the Reactive-Simulation Architecture (RSA) folder structure
# Windows PowerShell
# Usage:  ./rsa-scaffold.ps1 base     |     ./rsa-scaffold.ps1 online
param([ValidateSet("base","online")][string]$Action = "base")
$BASE = "Assets/_Project"

function Mk($paths) {
  foreach ($p in $paths) {
    New-Item -ItemType Directory -Force -Path $p | Out-Null
    $keep = Join-Path $p ".gitkeep"
    if (-not (Test-Path $keep)) { New-Item -ItemType File -Path $keep | Out-Null }
  }
}

# --- base: layers + asset folders ---
$base = @(
  "$BASE/Scripts/Foundation/Binding","$BASE/Scripts/Foundation/Pool","$BASE/Scripts/Foundation/Screens",
  "$BASE/Scripts/Domain/Models","$BASE/Scripts/Domain/Services",
  "$BASE/Scripts/Domain/Commands","$BASE/Scripts/Domain/Configs",
  "$BASE/Scripts/Presentation/_Shared","$BASE/Scripts/Presentation/HUD",
  "$BASE/Scripts/Actors/Player","$BASE/Scripts/Actors/Boss",
  "$BASE/Scripts/ECS/_Shared/Components","$BASE/Scripts/ECS/_Shared/Systems",
  "$BASE/Scripts/ECS/Enemy/Components","$BASE/Scripts/ECS/Enemy/Systems","$BASE/Scripts/ECS/Enemy/Authoring",
  "$BASE/Scripts/ECS/Projectile/Components","$BASE/Scripts/ECS/Projectile/Systems","$BASE/Scripts/ECS/Projectile/Authoring",
  "$BASE/Scripts/ECS/Bridges",
  "$BASE/Scripts/Reactors/Audio","$BASE/Scripts/Reactors/Camera",
  "$BASE/Scripts/Infrastructure/Save","$BASE/Scripts/Infrastructure/Audio","$BASE/Scripts/Infrastructure/Input",
  "$BASE/Scripts/Bootstrap/EntryPoints",
  "$BASE/Settings/Rendering","$BASE/Settings/Volumes",
  "$BASE/Data/Items","$BASE/Data/Enemies","$BASE/Data/Configs",
  "$BASE/Prefabs/UI","$BASE/Prefabs/Entities","$BASE/Prefabs/Characters",
  "$BASE/Art/Sprites/UI","$BASE/Art/Fonts",
  "$BASE/Audio/BGM","$BASE/Audio/SFX",
  "$BASE/Scenes/SubScenes"
)
# --- online: Network module (removable) ---
$online = @(
  "$BASE/Scripts/Network/Session","$BASE/Scripts/Network/Bridges",
  "$BASE/Scripts/Network/Entities","$BASE/Scripts/Network/Protocol",
  "$BASE/Scripts/Network/Transport",
  "$BASE/Scripts/Network/Presentation/Lobby","$BASE/Scripts/Network/Presentation/Chat",
  "$BASE/Scripts/Network/Bootstrap"
)

Mk $base
if ($Action -eq "online") { Mk $online }
Write-Host "OK  $Action created"
