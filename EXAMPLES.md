# Examples
Thanks for looking at Yyzzy as your server side entity system. If you are looking to get started quickly, there are two types of examples you may find.  
(1) a rich test suite showing the different features of Yyzzy and how they are used.  
(2) comprehensive examples that look like familiar games, simplified and with or without a rich user interface (may be text/terminal instead of GUI/controller)
# Functional Correctness Examples
Please look in "test/\*" for snippets of the expected usage of each feature of _Yyzzy_.  
This test library is structured so that you can mix and match feature usage at any level of abstraction:
- Data
  - lowest level of abstraction
  - module + struct based
- Standard Library
  - no particular runtime dependencies
  - Assumes entities are operated on using the Yyzzy, Yyzzy.Entity, and Yyzzy.Properties module functions. 
- Runtime System (RTS)
  - Otp or server protocol dependant
- DSL
  - generates lower levels
  - elixir macro based
  - some EEx features for language mixins

Each feature should be backwards compatible (broken down into a lower level), but may violate assumptions made at the higher levels. For instance if you made your own runtime system that didn't adhere to any Yyzzy RTS protocol.

# Complete Examples of Games

Complete games are currently under construction and won't be available until preliminary DSL features are implemented. Slated for examples are:
- Pong-like
  - 1-2 players
  - ad hoc physics and score
- Bejeweled-like
  - 1 player
  - physics, score, and persistence
- Sims-like (1 player)
  - 1 player
  - simple AI decision tree entities
- Simple RPG
  - 1 player
- Visual Novel / CYOA / Rot3K-like / Fire Emblem-like
  - 1 player
  - Inspired by the work of (Christine Love)[https://twitter.com/christinelove]
    - ebb / flow based events (rhythmic?) rather than explicit time or stat
    - heavy in metavariables and unobtrusive, persistent state
  - Inspired by the (comparative assessment of Emily Short)[https://emshort.wordpress.com/2016/02/15/set-check-or-gate-a-problem-in-personality-stats/]
    - opposed stats (parametric) and morality / trait systems (ad hoc)
    - interop. between character stat "model", user (inter)action "controller" and visual cue and information "view"
  - Going to be a real trial since many VN authors want to work in a high level DSL space, but escape to a more powerful language in complicated edge cases.
- Simple (MMO)RPG / MUD
  - n player
  - a permutation of simple rpg to show how minimally you can add distributed logic to a Yyzzy game
- Hereland Farland
  - n player
  - A game around musical collaboration and discovery
  - multiple views
- Chip/Pi Virtual Pet
  - n players
  - n autonomous pets on embedded hardware
  - Distribute game server across a distributed, peer-to-peer network
  - Multiple Views and IO
