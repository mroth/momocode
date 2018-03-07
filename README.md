# MomoCode 🍑

This proof-of-concept exhibits a representative visual fingerprint for a 20-byte
address, such as those found on the Ethereum network, by using Emoji Unicode
glyphs. The representation is designed to be easily visually distinguished by a
human, using commonly supported and visually distinct symbols, that can be
easily transmitted without having to rely on image generation/storage/serving.

For example, `0x583031d1113ad414f02576bd6afabfb302140225` can be more visually
distinctly represented as:

    🎡🎲🌟🌱🌲
    🐱🐪🐝👚🍬
    🌷🐊🍱🐳🎓
    🐾🐁🐂👨🎈

Sample code is provided as a Solidity library composed of "pure" functions
written with inline assembly, for low execution gas costs. (or zero cost when
called locally)

Note by design this encoding provides no [avalanching][1], e.g. a small change
in the input hash will result in an equivalently small change to the visual
representation, so if your goal in visual fingerprinting is to provide robust
_change detection_ for the end-user, then you must be sure to hash the input
first. For convenience, the library has built in `hashEncode...` functions that
will do this for you automatically via the RIPEMD-160 algorithm.

[1]: https://en.wikipedia.org/wiki/Avalanche_effect


## Usage
### Solidity
For now, see natspec documentation in the files themselves.

All encoding operations are `pure` functions written in inline assembly.

### JavaScript
A minimal Javascript library is provided. Currently the only usage of the
JavaScript library is simply to generate the encoded data constants for the
Solidity contract, thus it is not exacty super robust.


### Display
When displaying visually to a user, I recommend splitting into a 4x5 grid, as
the rectangular format makes it easier to visually parse for differences even
faster.

## Installation
TODO

## Technical
TODO

## TODO
- [ ] Replace with 256 hand-picked 4-byte emoji optimized for visual distinction and compatibility.
- [ ] Flesh out the JS library so people can do equivalent stuff client side if desired.


## Prior Art
This is not a new idea by any means, just adopting it to blockchain addresses.
See for example:

 1. ["Visualizing hex dumps with Unicode Emoji"](http://www.windytan.com/2014/10/visualizing-hex-bytes-with-unicode-emoji.html) by Oona Räisänen
 2. [base💯](https://github.com/AdamNiederer/base100) authored by Adam Niederer
