## Yyzzy Principles
A list of principles that Yyzzy should not break.
If Yyzzy breaks any of these principles then an issue should be filed to either:

- Fix it asap
- Amend the principle

## Glossary
YDS: Yyzzy Data Structure  
YMF: Yyzzy Module Function
### Any Game State is recreatable by building or composing Yyzzy Data Structures
Yyzzy is striving to be declarative as much as possible, so any game state should not be hidden in the implementation, but rather should be creatable by defining a Yyzzy data structure. Some members of the Yyzzy data structure may be by reference, and defined else where, which is ok even though it could result in a stale game state.
### All interactions with the game world must be expressed as a transformation of our YDS.

### Yyzzy should minimize nominal logical rules and maximize (prefer) pattern matching.
