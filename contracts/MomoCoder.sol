pragma solidity ^0.4.18;

/// @title An encoder to represent bytes20/address values as a visual emoji fingerprint.
/// @author Matthew Rothenberg
contract MomoCoder {

    // For simplicity/testing, for now we use the exact same 256 emoji as
    // http://www.windytan.com/2014/10/visualizing-hex-bytes-with-unicode-emoji.html
    // TODO: replace with better set of hand-picked emoji.
    //
    // const EMOJIZ = "🌀🌂🌅🌈🌙🌞🌟🌠🌰🌱🌲🌳🌴🌵🌷🌸🌹🌺🌻🌼🌽🌾🌿🍀🍁🍂🍃🍄🍅\
    // 🍆🍇🍈🍉🍊🍋🍌🍍🍎🍏🍐🍑🍒🍓🍔🍕🍖🍗🍘🍜🍝🍞🍟🍠🍡🍢🍣🍤🍥🍦🍧🍨🍩🍪🍫🍬🍭🍮🍯\
    // 🍰🍱🍲🍳🍴🍵🍶🍷🍸🍹🍺🍻🍼🎀🎁🎂🎃🎄🎅🎈🎉🎊🎋🎌🎍🎎🎏🎒🎓🎠🎡🎢🎣🎤🎥🎦🎧🎨🎩\
    // 🎪🎫🎬🎭🎮🎯🎰🎱🎲🎳🎴🎵🎷🎸🎹🎺🎻🎽🎾🎿🏀🏁🏂🏃🏄🏆🏇🏈🏉🏊🐀🐁🐂🐃🐄🐅🐆🐇🐈\
    // 🐉🐊🐋🐌🐍🐎🐏🐐🐑🐒🐓🐔🐕🐖🐗🐘🐙🐚🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐨🐩🐪🐫🐬🐭🐮🐯\
    // 🐰🐱🐲🐳🐴🐵🐶🐷🐸🐹🐺🐻🐼🐽🐾👀👂👃👄👅👆👇👈👉👊👋👌👍👎👏👐👑👒👓👔👕👖👗👘\
    // 👙👚👛👜👝👞👟👠👡👢👣👤👥👦👧👨👩👪👮👯👺👻👼👽👾👿💀💁💂💃💄💅";
    //
    // Solidity does not allow for constant arrays (even of fixed size), so
    // we encode into a bytes array as a hex constant. To generate this,
    // use the included JS library.
    bytes constant internal PEMOJIZ = hex"f09f8c80f09f8c82f09f8c85f09f8c88f09f8c99f09f8c9ef09f8c9ff09f8ca0f09f8cb0f09f8cb1f09f8cb2f09f8cb3f09f8cb4f09f8cb5f09f8cb7f09f8cb8f09f8cb9f09f8cbaf09f8cbbf09f8cbcf09f8cbdf09f8cbef09f8cbff09f8d80f09f8d81f09f8d82f09f8d83f09f8d84f09f8d85f09f8d86f09f8d87f09f8d88f09f8d89f09f8d8af09f8d8bf09f8d8cf09f8d8df09f8d8ef09f8d8ff09f8d90f09f8d91f09f8d92f09f8d93f09f8d94f09f8d95f09f8d96f09f8d97f09f8d98f09f8d9cf09f8d9df09f8d9ef09f8d9ff09f8da0f09f8da1f09f8da2f09f8da3f09f8da4f09f8da5f09f8da6f09f8da7f09f8da8f09f8da9f09f8daaf09f8dabf09f8dacf09f8dadf09f8daef09f8daff09f8db0f09f8db1f09f8db2f09f8db3f09f8db4f09f8db5f09f8db6f09f8db7f09f8db8f09f8db9f09f8dbaf09f8dbbf09f8dbcf09f8e80f09f8e81f09f8e82f09f8e83f09f8e84f09f8e85f09f8e88f09f8e89f09f8e8af09f8e8bf09f8e8cf09f8e8df09f8e8ef09f8e8ff09f8e92f09f8e93f09f8ea0f09f8ea1f09f8ea2f09f8ea3f09f8ea4f09f8ea5f09f8ea6f09f8ea7f09f8ea8f09f8ea9f09f8eaaf09f8eabf09f8eacf09f8eadf09f8eaef09f8eaff09f8eb0f09f8eb1f09f8eb2f09f8eb3f09f8eb4f09f8eb5f09f8eb7f09f8eb8f09f8eb9f09f8ebaf09f8ebbf09f8ebdf09f8ebef09f8ebff09f8f80f09f8f81f09f8f82f09f8f83f09f8f84f09f8f86f09f8f87f09f8f88f09f8f89f09f8f8af09f9080f09f9081f09f9082f09f9083f09f9084f09f9085f09f9086f09f9087f09f9088f09f9089f09f908af09f908bf09f908cf09f908df09f908ef09f908ff09f9090f09f9091f09f9092f09f9093f09f9094f09f9095f09f9096f09f9097f09f9098f09f9099f09f909af09f909bf09f909cf09f909df09f909ef09f909ff09f90a0f09f90a1f09f90a2f09f90a3f09f90a4f09f90a5f09f90a6f09f90a7f09f90a8f09f90a9f09f90aaf09f90abf09f90acf09f90adf09f90aef09f90aff09f90b0f09f90b1f09f90b2f09f90b3f09f90b4f09f90b5f09f90b6f09f90b7f09f90b8f09f90b9f09f90baf09f90bbf09f90bcf09f90bdf09f90bef09f9180f09f9182f09f9183f09f9184f09f9185f09f9186f09f9187f09f9188f09f9189f09f918af09f918bf09f918cf09f918df09f918ef09f918ff09f9190f09f9191f09f9192f09f9193f09f9194f09f9195f09f9196f09f9197f09f9198f09f9199f09f919af09f919bf09f919cf09f919df09f919ef09f919ff09f91a0f09f91a1f09f91a2f09f91a3f09f91a4f09f91a5f09f91a6f09f91a7f09f91a8f09f91a9f09f91aaf09f91aef09f91aff09f91baf09f91bbf09f91bcf09f91bdf09f91bef09f91bff09f9280f09f9281f09f9282f09f9283f09f9284f09f9285";

    function MomoCoder() public {
        // as an integrity check, verify our internal data is of expected size
        assert(PEMOJIZ.length == 1024);
    }

    /*
        Initial slower way of doing things, but avoiding any usage of inline assembly.
        TODO: Deprecate and remove all this code eventually, leave it around for testing for now.
    */
    /// @dev deprecated
    function _emojiBytesForPosition(uint8 n) pure internal returns (bytes1, bytes1, bytes1, bytes1) {
        uint16 start = uint16(n)*4;
        return (PEMOJIZ[start], PEMOJIZ[start+1], PEMOJIZ[start+2], PEMOJIZ[start+3]);
    }

    /// @dev deprecated
    function _encodeToString(bytes20 _bytes) pure internal returns (string) {
        bytes memory output = new bytes(80);
        bytes1 a; bytes1 b; bytes1 c; bytes1 d;
        for (uint8 i = 1; i <= 20; i++) {
            uint8 idx = 4*i;
            (a,b,c,d) = _emojiBytesForPosition(uint8(_bytes[i-1]));
            output[idx-4] = a;
            output[idx-3] = b;
            output[idx-2] = c;
            output[idx-1] = d;
        }
        return string(output);
    }

    /// @dev deprecated
    function encodeToStringDeprecated(bytes20 _bytes) pure public returns (string) {
        return _encodeToString(_bytes);
    }
    /// @dev deprecated
    function encodeToStringDeprecated(address _address) pure external returns (string) {
        return encodeToStringDeprecated(bytes20(_address));
    }

    /*
        The way of doing things now.
        Better, faster, stronger... using inline assembly.
    */

    // Extracts bytes for a single position.
    function _extractBytesForPosition(uint8 n) pure internal returns (bytes4) {
        bytes memory table = PEMOJIZ; // <- inline assembly can't access constants (sigh)
        uint16 start = uint16(n)*4;
        bytes4 pos;
        assembly {
            pos := mload(add(add(table, 0x20), start))
        }
        return pos;
    }

    // More efficient version of above which extracts bytes for all positions without multiple
    // function invocations. In theory this could help avoiding extra memory loads of PEMOJIZ table?
    function _extractBytesForAllPositions(bytes20 _data) pure internal returns (bytes4[20]) {
        bytes memory table = PEMOJIZ;
        bytes4[20] memory results;

        bytes4 res; // allocated placeholder
        for (uint8 i = 0; i < _data.length; i++) {
            uint16 startPos = uint16(_data[i])*4;
            assembly {
                res := mload(add(add(table, 0x20), startPos))
            }
            results[i] = res;
        }
        return results;
    }

    /// @notice Encodes data to a fingerprint.
    /// @param _data The data to be encoded.
    /// @return An array of 20 `bytes4` values each representing an emoji glyph.
    /// @dev This is the version designed to be called from another contract, as
    /// currently contracts cannot access functions that return non-fixed length
    /// values (e.g. string or bytes), and there is no built-in bytes80 type.
    function encode(bytes20 _data) pure public returns (bytes4[20]) {
        return _extractBytesForAllPositions(_data);
    }

    /// @notice Encodes an address to a fingerprint array.
    /// @param _address The address to be encoded.
    /// @return An array of 20 `bytes4` values each representing an emoji glyph.
    /// @dev This is merely a convenience function that automatically typecasts
    /// from `address => bytes20`, to make things simpler for external callers.
    function encode(address _address) pure public returns (bytes4[20]) {
        return encode(bytes20(_address));
    }

    /// @dev Faster version of `_encodeToString` that uses inline assembly to
    /// build up the output byte array.
    function _encodedToStringFast(bytes4[20] _byteArray) pure internal returns (string) {
        bytes memory tempBytes = new bytes(80);
        assembly {
            let mc := add(tempBytes, 0x20)
            for { let i := 0 } lt(i, 20) {
                i  := add(i,  1)
                mc := add(mc, 4)
            } {
                mstore(mc, mload(add(_byteArray, mul(i, 0x20))))
            }
        }
        return string(tempBytes);
    }

    /// @notice Encodes data to a fingerprint string.
    /// @param _data The data to be encoded.
    /// @return A `string` representing the entire emoji fingerprint (20 glyphs).
    /// @dev Convenience function for external calls to display results to user.
    function encodeToString(bytes20 _data) pure public returns (string) {
        return _encodedToStringFast(encode(_data));
    }

    /// @notice Encodes an address to a fingerprint string.
    /// @param _address The address to be encoded.
    /// @return A `string` representing the entire emoji fingerprint, with 20 glyphs.
    /// @dev This is merely a convenience function that automatically typecasts
    /// from `address => bytes20`, to make things simpler for external callers.
    function encodeToString(address _address) pure external returns (string) {
        return encodeToString(bytes20(_address));
    }

    /// @notice Hashes an arbitrary amount of bytes, then encodes to a fingerprint array.
    /// @param _bytes The data to be hashed and then encoded.
    /// @return An array of 20 `bytes4` values each representing an emoji glyph.
    /// @dev this is the equivalent of doing ripemd160(_bytes) and passing to encode(),
    /// and is just provided for convenience.
    function hashEncode(bytes _bytes) pure external returns (bytes4[20]) {
        return encode(ripemd160(_bytes));
    }

    /// @notice Same as `hashEncode()`, but returns a string suitable for display.
    /// @param _bytes The data to be hashed and then encoded.
    /// @return A `string` representing the entire emoji fingerprint, with 20 glyphs.
    /// @dev this is the equivalent of doing encodeToString(ripemd160(_bytes)),
    /// and is just provided for convenience.
    function hashEncodeToString(bytes _bytes) pure external returns (string) {
        return encodeToString(ripemd160(_bytes));
    }

}
