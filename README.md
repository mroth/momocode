# MomoCode 🍑

This proof-of-concept exhibits a representative visual fingerprint for a 20-byte
address, such as those found on the Ethereum network, by using Emoji Unicode
glyphs. The representation is designed to be easily visually distinguished by a
human, using commonly supported and visually distinct symbols, that can be
easily transmitted without having to rely on image generation/storage/serving.

For example, `0x627306090abab3a6e1400e9345bc60c78a8bef57` can be more visually
distinctly represented as:

    🎡🎲🌟🌱🌲
    🐱🐪🐝👚🍬
    🌷🐊🍱🐳🎓
    🐾🐁🐂👨🎈

Note by design this encoding provides no [avalanching][1], e.g. a small change
in the input hash will result in an equivalently small change to the visual
representation, so if your goal in visual fingerprinting is to provide robust
_change detection_ for the end-user, then you must be sure to hash the input
first. (For convenience, the included libraries have built-in optional hashing
functions that can do this for you.)

[1]: https://en.wikipedia.org/wiki/Avalanche_effect


## Libraries

### [Solidity](solidity/)

All encoding operations are `pure` functions written in inline assembly, for low
execution gas costs (or zero cost when called locally). For docs, see natspec
documentation in the source files themselves.

### [Go](go/)

See the godocs.


## Visual Representation

When displaying visually to a user, I recommend splitting the string into a 4x5
grid via linebreaks, as the rectangular format makes it easier to visually parse
for differences even faster.

The Go library contains a `Grid()` function to do this for you.


## Future Work

- Replace the 256 4-byte emoji with hand-picked choices optimized for visual
  distinction and compatibility.
- Flesh out a JavaScript library so people can do equivalent stuff client side
  in the browser if desired.


## Prior Art

This is not a new idea by any means, just adapting it to Ethereum addresses. See
for example:

 1. ["Visualizing hex dumps with Unicode Emoji"](http://www.windytan.com/2014/10/visualizing-hex-bytes-with-unicode-emoji.html) by Oona Räisänen
 2. [base💯](https://github.com/AdamNiederer/base100) authored by Adam Niederer
