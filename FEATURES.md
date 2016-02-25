# Features
## Timeline
### Big Picture:
This library is being built with what you could consider v0.1.0 features in mind. The development cycle is looking like:
#### v0.0.1 :fireworks:
Data Structures > Data Structure Tests > Module Functions > Module Function Tests > Library Helper Functions > Library Helper Function Tests > Integration Tests and basic low-level examples
#### v0.0.2
Runtime System Architecture > Runtime System Tests
#### v0.0.3
Distributed Runtime System Augmentation > Distributed Runtime System Tests > Distributed Data Structure Augmentation > Distributed Data Structure Tests
#### v0.0.4
DSL and Elixir Code gen > DSL Tests
#### v0.0.5
EEx templates and Endpoint Generation for supported GUI/Game Engines
#### v0.1.0
End to End Integration Tests
### Details
#### Done:

- Entity Tree Data Structure
  - Enumerable Behavior
  - Polymorphic Merge behavior
    - Merge Policies as a fun\2
  - get and update behaviors by Structure (name), Property, or Kind
  - put and maintaining hierarchy uid key structure
  - retree (pop and promote)
  - Union datatype
    - Subentities may be function surrogates that can get, update, info, or delete Yyzzys.
    - make_lambda helper to construct a subentity of this type in general
    - Genserver lambda implementation (instance)
  - get_all, flatten an entire tree (grab current struct value of all instances, deep copy)
  - Search
    - by key
    - by key and update in place

- Property Data Structure
  - generation (creation)
  - use construct for custom defined property structs
  - Templating and Updating

#### TODO
- get_schema (produces a map of key to type)
- Entity Template Generators
  - compose subentities
  - Standard Library Entity Templates
  - Yyzzy.Entity.Node
  - Yyzzy.Entity.DB
- Runtime System
  - setup, update, msg effect (draw), destroy, swap
  - FRP sugar: save state, load state, time travel, event handling / continuation
- eDSL Wrapper
  - generating templates
- Standard Library
- Unit and Integration Tests
  - small games in Library + Runtime form
  - small games in eDSL forms
- Developer Documentation
  - Add doc tests
  - Library + Runtime documentation
  - eDSL documentation
- EEx templates for popular game engine integration
  - Three.js
  - LibGDX
  - Monogame
  - Unity?
  - Lumberyard?
