# rsa-scaffold.ps1 — generate the Reactive-Simulation Architecture (RSA) folder structure
# Windows PowerShell
# Usage:  ./rsa-scaffold.ps1 base     |     ./rsa-scaffold.ps1 online
param([ValidateSet("base","online")][string]$Action = "base")
# NOTE: PowerShell variable names are case-insensitive, so this must not
# collide with the folder-list variables below ($base / $online).
$Root = "Assets/_Project"

function Mk($paths) {
  foreach ($p in $paths) {
    New-Item -ItemType Directory -Force -Path $p | Out-Null
    $keep = Join-Path $p ".gitkeep"
    if (-not (Test-Path $keep)) { New-Item -ItemType File -Path $keep | Out-Null }
  }
}

# --- base: layers + asset folders ---
$base = @(
  "$Root/Scripts/Foundation/Binding","$Root/Scripts/Foundation/Pool","$Root/Scripts/Foundation/Screens",
  "$Root/Scripts/Domain/Models","$Root/Scripts/Domain/Services",
  "$Root/Scripts/Domain/Commands","$Root/Scripts/Domain/Configs",
  "$Root/Scripts/Presentation/_Shared","$Root/Scripts/Presentation/HUD",
  "$Root/Scripts/Actors/Player","$Root/Scripts/Actors/Boss",
  "$Root/Scripts/ECS/_Shared/Components","$Root/Scripts/ECS/_Shared/Systems",
  "$Root/Scripts/ECS/Enemy/Components","$Root/Scripts/ECS/Enemy/Systems","$Root/Scripts/ECS/Enemy/Authoring",
  "$Root/Scripts/ECS/Projectile/Components","$Root/Scripts/ECS/Projectile/Systems","$Root/Scripts/ECS/Projectile/Authoring",
  "$Root/Scripts/ECS/Bridges",
  "$Root/Scripts/Reactors/Audio","$Root/Scripts/Reactors/Camera",
  "$Root/Scripts/Infrastructure/Save","$Root/Scripts/Infrastructure/Audio","$Root/Scripts/Infrastructure/Input",
  "$Root/Scripts/Bootstrap/EntryPoints",
  "$Root/Settings/Rendering","$Root/Settings/Volumes",
  "$Root/Data/Items","$Root/Data/Enemies","$Root/Data/Configs",
  "$Root/Prefabs/UI","$Root/Prefabs/Entities","$Root/Prefabs/Characters",
  "$Root/Art/Sprites/UI","$Root/Art/Fonts",
  "$Root/Audio/BGM","$Root/Audio/SFX",
  "$Root/Scenes/SubScenes"
)
# --- online: Network module (removable) ---
$online = @(
  "$Root/Scripts/Network/Session","$Root/Scripts/Network/Bridges",
  "$Root/Scripts/Network/Entities","$Root/Scripts/Network/Protocol",
  "$Root/Scripts/Network/Transport",
  "$Root/Scripts/Network/Presentation/Lobby","$Root/Scripts/Network/Presentation/Chat",
  "$Root/Scripts/Network/Bootstrap"
)

Mk $base
if ($Action -eq "online") { Mk $online }
Write-Host "OK  $Action created"
