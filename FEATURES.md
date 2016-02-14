# Features
## Timeline
### Big Picture:
This library is being built with what you could consider v0.1.0 features in mind. The development cycle is looking like:
#### v0.0.1
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
- Property Data Structure
  - generation (creation)
  - use construct for custom defined property structs
  - Templating and Updating

#### Todo:
- Entity Tree Data Structure
  - Namespacing and enforcement of key <-> uid
  - Search
    - by key
    - by property
- Distributed reference behavior for child entities
  - Either using the struct as a type to pattern match
  - or imitation Monadic structure with a tuple
- Async options for merging, mapping, and updating.
