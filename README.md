<h1 align="center">
     <img src="./assets/nixos-logo.png" style="height: 1em; vertical-align: middle; margin-right: 0.5em;">
     NixOS Configuration Files
     <img src="./assets/nixos-logo.png" style="height: 1em; vertical-align: middle; margin-right: 0.5em;">
</h1>

<div align="center">
Written and configured with:

![Nix](https://img.shields.io/badge/Nix-5277C3.svg?&logo=NixOS&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-%232C2D72.svg?logo=lua&logoColor=white)
![QML](https://img.shields.io/badge/QML-41CD52?logo=qt&logoColor=fff)

</div>

Multi-host configuration files for my NixOS machines.

### What is Nix/NixOS?
NixOS is an atomic, declarative, immutable Linux distribution that offers both
rolling and stable releases ([More Info](https://en.wikipedia.org/wiki/NixOS)).
I first tried NixOS in June 2024 and have been daily driving it since around
that time.

Host Devices
------------
| Hostname  | Device Type     | Active | Primary Purpose       | Namesake                                                                                 |
|-----------|-----------------|--------|-----------------------|------------------------------------------------------------------------------------------|
| RioTinto  | Desktop         | 🗹      | Gaming                | [Rio Tinto, Spain](https://en.wikipedia.org/wiki/Rio_Tinto_(river))                      |
| celebrant | Laptop          | 🗹      | Workstation           | [Celebrant, Middle Earth](https://lotr.fandom.com/wiki/Celebrant)
| tokoro    | Server          | 🗹      | Jellyfin/File Backups | [Tokoro River, Japan](https://en.wikipedia.org/wiki/Tokoro_River)                        |
| wsl       | Virtual Machine | 🗹      | WSL Config            | [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) |
| vaal      | Laptop          | ☐      | School                | [Vaal River, South Africa](https://en.wikipedia.org/wiki/Vaal_River)                     |

##### Note on Names
We have a long-standing tradition at my house to name our devices after a
river. After a few decades of this, basic names like "Nile" are long gone.
My desktop is named after the Rio Tinto because when I first started
learning Spanish I used to speak the dialect from Spain. Celebrant is named
after the Celebrant river (pronounced [ˈkɛlɛbrant]), which comes from "celeb,"
meaning silver, and "brant," meaning something like stream. The computer is
named so because it has a silvery-blue chassis, and because I was rewatching
The Hobbit and The Lord of the Rings when I named it. Tokoro is a river in
Japan. I have always been fascinated by Japanese culture (original, I know
/s), so I just chose a name that sounded cool. Vaal was chosen because the
name looked cool and because I found the letter v appealing.

Screenshots
-----------
![screenshot_1](./assets/screenshot_1.png)
![screenshot_2](./assets/screenshot_2.png)
<div align="center"><i>Screenshots taken on celebrant.</i></div>

Config Design Philosophy
------------------------
The exact configuration of a given host is defined in terms of traits, which
are essentially composable modules of nix code.

Some traits define the general type of system that I'm building. This allows
me to compose functionality without repeating myself, and creates the
necessary granularity to define systems with complex use cases. The current
hierarchy looks something like this:
```
Any
 ├─ Machine
 │    ├─ Graphical
 │    │    └─ Workstation
 │    └─ Server
 └─ WSL
```
Where `Any` is the most general and `Workstation` is the most specific.

There also several traits that define additional functionality/requirements
for a given system. Note that some of the hierarchical traits imply the
the presence of extension traits. For example all systems have the `Neovim`
trait (because I will always need to edit text on any system).

The current list is as follows:
- neovim
- gaming
- jellyfin-service
- nvidia
- syncthing
- virtualisation

##### Current traits applied to each system
- RioTinto: Workstation + Gaming + Nvidia
- celebrant: Workstation
- Tokoro: Server + Syncthing + JellyfinService
- wsl: WSL

Directory Structure
-------------------
- Assets - Static assets for certain applications
- Checks - Testing for my configs
- Docs - Documentation and notes
- Hosts - Entry points for the configs
- Lib - Custom nix utilities
- Modules - Everything else
   - Dots - Configurations for specific applications
   - Traits - Definitions of the capabilities a host can have
   - Constants - Variables that may be re-used in multiple places.
- Overlay - Random things I've packaged and overlaid into my local `nixpkgs`
- Shells - Definitions for Nix DevShells
- Templates - Flake templates for use with `nix flake init`
