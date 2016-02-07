# Yyzzy Test Suite
These tests are designed in a MPA-brand "layered dsl fashion" which follow Elixir-friendly hierarchy of needs. That is, Yyzzy can offer you a computational model for structuring your server side game entities following the hierarchy:
data > functions > modules > runtime > macros > dsl.
The test suite is organized in folders analogous to this, and tests further to the right compose features on the left, trading control (e.g. being able to specify your own runtime system) for power (e.g. generating a lot of free stuff for you to just use). It is suggested to look at the tests, starting from data and moving up in power, to find the level you wish to program at for your game.

Note, you can always escape down to add more control if need be, since all higher features are built using lower ones and should be "backwards compatible", but it may not be true to escape to using the DSL or runtime specific macros if you implement your own. I will do my best, though, to expose all design decisions through Elixir protocols and callbacks so that if you do choose to build your own tools, you may implement them in such a way that the dsl can work, but no guarantees :)

## Data Tests
The bare computational model of the Yyzzy entity structure.

This test suite is to show how you can program in Using Yyzzy structs to
structure entities in your game at the most minimal level. At this stage:
- Yyzzy gives you
  - A struct to recursively declare adhoc game entities
  - A module that defines functions to manipulate Yyzzy objects
- Yyzzy does not give you
  - A way to define a state machine or other abstraction to modify Yyzzy objects
  - patterns or callbacks to implement against to define the rules of your game.
