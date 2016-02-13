# Examples
Thanks for looking at Yyzzy as your server side entity system. If you are looking to get started quickly, there are two types of examples you may find.  
(1) a rich test suite showing the different features of Yyzzy and how they are used.  
(2) comprehensive examples that look like familiar games, simplified and with or without a rich user interface (may be text/terminal instead of GUI/controller)
# Functional Correctness Examples

Please look in "test/\*" for snippets of the expected usage of each feature of _Yyzzy_.  
This test library is structured so that you can mix and match feature usage at any level of abstraction:
- Data
  - lowest level of abstraction
- Library
  - module + struct based
  - no otp or server dependence
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
- Simple (MMO)RPG / MUD
  - n player
  - a permutation of simple rpg to show how minimally you can add distributed logic to a Yyzzy game
- Hereland Farland
  - n player
  - A game around musical collaboration and discovery
  - multiple views
