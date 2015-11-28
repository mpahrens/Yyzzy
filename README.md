# Yyzzy

Serverside-game framework for Elixir
## Purpose
a Data Driven, functional serverside alternative to the OOP create-update-render-destroy model to Games and Screens.
#### TODO
Main internals are TBD but the gist is to combine some features of propagators as FRP Behaviours, and Entity Oriented Design (that is, we don't care about what game objects are at every step, we just transform over them since they are data). This section will be fleshed out as we make some decisions.

## Features
- Data-driven game state definitions as a Yyzzy data structure
- Yyzzy Module for game specific functions and operations on game data structure
- Gen Server and Supervisor (OTP) implementation for Runtime System and distribution helpers
- eDSL wrapper for defining OTP actors above and using the Module in an elixir (plug / |>) like way.
- [TBD] Game plugins that use the Yyzzy framework as EEx DSLs
## Getting started
