# rsa-scaffold.ps1 — generate the Reactive-Simulation Architecture (RSA) folder structure
# Windows PowerShell
# Usage:  ./rsa-scaffold.ps1 base     |     ./rsa-scaffold.ps1 online
param([ValidateSet("base","online")][string]$Action = "base")
# Work out where "Assets/_Project" should go, based on where the script is run from,
# so running inside Assets/ does not create a nested Assets/Assets/.
# NOTE: PowerShell variable names are case-insensitive, so $Root must not
# collide with the folder-list variables below ($base / $online).
$Cwd        = (Get-Location).Path
$Leaf       = Split-Path $Cwd -Leaf
$ParentLeaf = Split-Path (Split-Path $Cwd -Parent) -Leaf

if     ($Leaf -eq "_Project" -and $ParentLeaf -eq "Assets") { $Root = "." }            # already inside Assets/_Project
elseif ($Leaf -eq "Assets")                                 { $Root = "_Project" }     # inside Assets/
else                                                        { $Root = "Assets/_Project" }  # Unity project root

$script:Created = 0
$script:Skipped = 0

# create a folder only when it does not exist yet — existing folders are left untouched
function Mk($paths) {
  foreach ($p in $paths) {
    if (Test-Path -LiteralPath $p -PathType Container) {
      $script:Skipped++
    } else {
      New-Item -ItemType Directory -Force -Path $p | Out-Null
      $script:Created++
    }
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
# --- online: Network module (swappable netcode impl) ---
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
Write-Host "    $($script:Created) created, $($script:Skipped) skipped (already exists)  ->  $Root/"
