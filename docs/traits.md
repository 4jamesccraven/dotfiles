# Traits
I compose my systems from a combination of Nix modules that I call "traits"
(taken from the Rust terminology). In general, a host is composed of one base
trait that describes what kind of system it is, and several other tangential
traits that provide additional functionality.

## Hierarchical Traits
Right now these are the base/hierarchical traits I use:
```
any
├─ wsl
└─ machine
   ├─ graphical
   │  └─ workstation
   └─ server
```
In practice, I don't use most of these directly, instead opting for the leaf
nodes such as `server` or `workstation`. These hierarchical traits often have
some custom configuration options as well. For example, I can change which
display manager I use like so:
```nix
{
  ext.displayManager = "ly"; # or gdm, cosmic
}
```

## Other traits
Many of these are implicitly added with certain hierarchical traits. For
instance, all of my host targets have access to [my neovim
config](./modules/traits/neovim.nix), as it is part of the `any` trait.

The traits:
- gaming
- neovim
- nvidia
- syncthing
- virtualisation
