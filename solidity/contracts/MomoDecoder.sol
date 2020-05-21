pragma solidity ^0.4.18;

import "./MomoCoder.sol";

/// @title Extends MomoCoder to have decoding capabilities. Note that you
/// probably don't actually want to do this, as doing these operations
/// in pure memory operations with Solidity is currently fairly expensive.
/// @author Matthew Rothenberg
contract MomoDecoder is MomoCoder {

    /// @notice Decodes encoded data string back into a bytes20 value.
    /// @param _encodedAddress A string to be decoded.
    /// @return The original bytes20 value (or address).
    /// @dev If you want an `address`, you can simply typecast from `bytes20`.
    function decodeFromString(string _encodedAddress) public pure returns (bytes20) {
        bytes memory _data = bytes(_encodedAddress);
        require(_data.length == 80);
        return decode(_chunkData(_data));
    }

    /// @notice Decodes encoded data chunks back into a bytes20 value.
    /// @param _dataChunks A `bytes4[20]` of the data to be decoded.
    /// @return The original bytes20 value (or address).
    /// @dev If you want an `address`, you can simply typecast from `bytes20`.
    function decode(bytes4[20] _dataChunks) public pure returns (bytes20) {
        // First we need to build the hash table to do the decoding, we do it
        // here on execution since solidity does not allow us to have a constant
        // array or mapping, and we want to avoid the gas costs to put it in
        // storage.
        bytes4[256] memory _decodeTable = _generateCodeTable();

        // Attempting to write to specific bytes of a bytes20 in inline assembly
        // was causing an EVM error for reasons I couldn't deduce, so instead use
        // a bytes(20) memory and just load it into a byte20 at the end. This is
        // probably a win anyhow, since there is less assembly to read, and the
        // cost of a single extra bytes20 memory allocation is going to be trivial
        // compared to this giant inefficient loop anyhow.
        bytes memory _res = new bytes(20);
        for (uint8 i = 0; i < _dataChunks.length; i++) {
            bytes4 _target = _dataChunks[i];
            for (uint16 j = 0; j <= 255; j++) {
                if (_decodeTable[j] == _target) {
                    _res[i] = bytes1(uint8(j));
                    break;
                }
            }
        }
        bytes20 _tmp20;
        assembly {
            _tmp20 := mload(add(_res, 0x20))
        }
        return _tmp20;
    }

    // @dev converts the internal constant data into something more usable
    function _generateCodeTable() pure internal returns (bytes4[256]) {
        bytes memory _table = PEMOJIZ;
        bytes4[256] memory _codeTable;

        assembly {
            let src_mc := add(_table, 32)
            let dst_mc := _codeTable
            for { let i := 0 } lt(i, 256) {
                i :=  add(i, 1)
                src_mc := add(src_mc, 4)
                dst_mc := add(dst_mc, 32)
            } {
                mstore(dst_mc, mload(src_mc))
            }
        }
        return _codeTable;
    }

    // @dev Assumes bytes80, so only returns the first 20 chunks (80 bytes)
    function _chunkData(bytes _data) internal pure returns (bytes4[20]) {
        bytes4[20] memory _chunks;
        for (uint8 i = 0; i < 20; i++) {
            assembly {
                mstore(
                    add(_chunks, mul(i, 32)),
                    mload(add(add(_data, 32), mul(i, 4)))
                )
            }
        }
        return _chunks;
    }
}
