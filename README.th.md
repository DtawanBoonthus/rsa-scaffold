# rsa-scaffold

[English](README.md) | **ไทย**

สร้างโครง folder ของ **Reactive-Simulation Architecture (RSA)** สำหรับโปรเจกต์ Unity ด้วยคำสั่งเดียว — ไม่ต้องนั่งสร้าง folder ทีละอันตอนเริ่มโปรเจกต์ใหม่

---

## RSA คืออะไร

Architecture สำหรับเกม Unity ที่ใช้ **Layered + MVVM + Mediator (VitalRouter)** โดยแยกโค้ดตาม **2 execution model**:

| ฝั่ง | ทำงานแบบ | อยู่ที่ |
|---|---|---|
| **Reactive** (UI, เมนู, คะแนน) | รอ input แล้วตอบ | `Presentation/`, `Domain/` |
| **Simulation** (ศัตรู, กระสุน, ตัวละคร) | รันเองทุกเฟรม | `Actors/`, `ECS/` |

สองฝั่งไม่เรียกกันตรงๆ — คุยผ่าน **Mediator (VitalRouter)** จุดเดียว · ข้ามจาก ECS มาฝั่ง managed ผ่านตัวแปลง **Bridge** (`SystemBase`) · `Network/` เป็นโมดูลถอดออกได้ (offline-first)

---

## วิธีใช้

```bash
# Mac / Linux / Git Bash
bash rsa-scaffold.sh base       # โครง offline ครบ
bash rsa-scaffold.sh online     # base + โมดูล Network (multiplayer)
```

```powershell
# Windows PowerShell
./rsa-scaffold.ps1 base
./rsa-scaffold.ps1 online
```

รันในโฟลเดอร์รากของโปรเจกต์ Unity (ที่มีโฟลเดอร์ `Assets/` อยู่) — สคริปต์จะสร้างทุกอย่างใต้ `Assets/_Project/`

> สร้าง `.gitkeep` ให้ทุก folder เพื่อ commit folder ว่างขึ้น git ได้ · รันซ้ำได้ปลอดภัย (idempotent) ไม่ทับไฟล์เดิม

---

## เรียกจาก command line ได้เลย (ไม่ต้องโหลดไฟล์)

**Mac / Linux / Git Bash:**
```bash
curl -fsSL https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.sh | bash -s -- online
```

**Windows PowerShell:**
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.ps1))) online
```

ทั้งสอง URL ชี้ที่ tag `v1.0` — สคริปต์ที่รันวันนี้กับเดือนหน้าจะเป็นตัวเดียวกันเสมอ ถ้าอยากอัปเป็นเวอร์ชันใหม่ เปลี่ยน `v1.0` เป็น tag ที่ใหม่กว่าได้จาก [หน้า tags](https://github.com/DtawanBoonthus/rsa-scaffold/tags)

### ติดตั้งเป็น command ถาวร (เรียกสั้นๆ)

```bash
mkdir -p ~/bin
curl -fsSL https://raw.githubusercontent.com/DtawanBoonthus/rsa-scaffold/v1.0/rsa-scaffold.sh -o ~/bin/rsa-scaffold
chmod +x ~/bin/rsa-scaffold
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

จากนั้นในโปรเจกต์ไหนก็:
```bash
rsa-scaffold online
```

---

## โครงที่สร้าง

```text
Assets/_Project/
├── Scripts/
│   ├── Foundation/     เครื่องมือ generic ไม่รู้จักเกม (Pool, ScreenManager)
│   ├── Domain/         business logic — Pure C# เทสได้ (Models/Services/Commands/Configs)
│   ├── Presentation/   [Reactive] UI แบบ MVVM (ViewModel + View)
│   ├── Actors/         [Simulation] gameplay Mono ตัวน้อย (Player, Boss)
│   ├── ECS/            [Simulation] gameplay ตัวเยอะ (Enemy/Projectile + Bridges)
│   ├── Reactors/       รับ event ทำ side effect (Audio, Camera)
│   ├── Infrastructure/ ติดต่อโลกนอก (Save, Audio, Input)
│   ├── Bootstrap/      DI registration + wiring
│   └── Network/        โมดูล online ถอดได้ (เฉพาะ online) — Session/Bridges/Entities/Protocol/Transport
├── Settings/           Rendering / Volumes (URP)
├── Data/               ScriptableObject instances (.asset)
├── Prefabs/            UI / Entities / Characters
├── Art/                Sprites / Fonts
├── Audio/              BGM / SFX
└── Scenes/             + SubScenes/ (ECS bake target)
```

| Action | สร้าง |
|---|---|
| `base` | โครง offline ทั้งหมด (ไม่มี `Network/`) |
| `online` | `base` + โมดูล `Network/` สำหรับ multiplayer |

---

## กฎเหล็กของ RSA

1. `Domain/` เป็น Pure C# — ห้าม reference `UnityEngine.UI` / `Unity.Entities`
2. `ECS/` มี asmdef แยก ไม่ reference R3/VitalRouter/UI → Burst-safe
3. ข้าม ECS → managed ต้องผ่าน `ECS/Bridges/` (asmdef `_Project.ECS.Bridges`) เท่านั้น
4. `interface` อยู่ `Domain/` · impl ที่ผูก engine อยู่ `Infrastructure/` หรือ `Network/`
5. `using FishNet` (หรือ networking lib) ได้เฉพาะใน `Network/` · ไม่มีใครพึ่ง `Network/` กลับ → ถอดได้
6. Code (`.cs`) แยกจาก Asset (`.asset`/prefab/`.uxml`)

> โครงนี้สร้างแค่ *folder* — ตัว `.asmdef` ต้องเพิ่มเองตามกฎด้านบน
