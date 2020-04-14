package momocode

import (
	"crypto/sha1"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"sync"
)

var glyphs = [256]rune{
	'🌀', '🌂', '🌅', '🌈', '🌙', '🌞', '🌟', '🌠', '🌰', '🌱', '🌲', '🌳', '🌴', '🌵', '🌷',
	'🌸', '🌹', '🌺', '🌻', '🌼', '🌽', '🌾', '🌿', '🍀', '🍁', '🍂', '🍃', '🍄', '🍅', '🍆',
	'🍇', '🍈', '🍉', '🍊', '🍋', '🍌', '🍍', '🍎', '🍏', '🍐', '🍑', '🍒', '🍓', '🍔', '🍕',
	'🍖', '🍗', '🍘', '🍜', '🍝', '🍞', '🍟', '🍠', '🍡', '🍢', '🍣', '🍤', '🍥', '🍦', '🍧',
	'🍨', '🍩', '🍪', '🍫', '🍬', '🍭', '🍮', '🍯', '🍰', '🍱', '🍲', '🍳', '🍴', '🍵', '🍶',
	'🍷', '🍸', '🍹', '🍺', '🍻', '🍼', '🎀', '🎁', '🎂', '🎃', '🎄', '🎅', '🎈', '🎉', '🎊',
	'🎋', '🎌', '🎍', '🎎', '🎏', '🎒', '🎓', '🎠', '🎡', '🎢', '🎣', '🎤', '🎥', '🎦', '🎧',
	'🎨', '🎩', '🎪', '🎫', '🎬', '🎭', '🎮', '🎯', '🎰', '🎱', '🎲', '🎳', '🎴', '🎵', '🎷',
	'🎸', '🎹', '🎺', '🎻', '🎽', '🎾', '🎿', '🏀', '🏁', '🏂', '🏃', '🏄', '🏆', '🏇', '🏈',
	'🏉', '🏊', '🐀', '🐁', '🐂', '🐃', '🐄', '🐅', '🐆', '🐇', '🐈', '🐉', '🐊', '🐋', '🐌',
	'🐍', '🐎', '🐏', '🐐', '🐑', '🐒', '🐓', '🐔', '🐕', '🐖', '🐗', '🐘', '🐙', '🐚', '🐛',
	'🐜', '🐝', '🐞', '🐟', '🐠', '🐡', '🐢', '🐣', '🐤', '🐥', '🐦', '🐧', '🐨', '🐩', '🐪',
	'🐫', '🐬', '🐭', '🐮', '🐯', '🐰', '🐱', '🐲', '🐳', '🐴', '🐵', '🐶', '🐷', '🐸', '🐹',
	'🐺', '🐻', '🐼', '🐽', '🐾', '👀', '👂', '👃', '👄', '👅', '👆', '👇', '👈', '👉', '👊',
	'👋', '👌', '👍', '👎', '👏', '👐', '👑', '👒', '👓', '👔', '👕', '👖', '👗', '👘', '👙',
	'👚', '👛', '👜', '👝', '👞', '👟', '👠', '👡', '👢', '👣', '👤', '👥', '👦', '👧', '👨',
	'👩', '👪', '👮', '👯', '👺', '👻', '👼', '👽', '👾', '👿', '💀', '💁', '💂', '💃', '💄',
	'💅',
}

// errors returned by this package
var (
	ErrInvalidRune = errors.New("cannot decode contains invalid rune")
)

// Viz is a visual fingerprint representation of a [20]byte address, consisting
// of 20 emoji glyph runes.
type Viz [20]rune

func (v Viz) String() string {
	return string(v[:])
}

// Grid renders the Viz as a string with linebreaks to put the Viz in a
// rectangular shape to make it more recognizable to the human eye.
func (v Viz) Grid() string {
	return fmt.Sprintf("%s\n%s\n%s\n%s",
		string(v[0:5]),
		string(v[5:10]),
		string(v[10:15]),
		string(v[15:20]),
	)
}

// Encode a [20]byte address into a visual representation
func Encode(data [20]byte) Viz {
	var res Viz
	for i, b := range data {
		res[i] = glyphs[b]
	}
	return res
}

// Decode a glyph-based Viz v into an [20]byte address
func Decode(v Viz) ([20]byte, error) {
	initDecodeTable := func() {
		res := make(map[rune]byte, len(glyphs))
		for i, g := range glyphs {
			res[g] = uint8(i)
		}
		decodeTable = res
	}
	once.Do(initDecodeTable)

	var res [20]byte
	for i, glyph := range v {
		b, ok := decodeTable[glyph]
		if !ok {
			return res, ErrInvalidRune
		}
		res[i] = b
	}
	return res, nil
}

// package global decode table, will be lazily initialized upon first use,
// utilizing a sync.Once to ensure a single initialization even if package
// is being utilized concurrently.
var (
	decodeTable map[rune]byte
	once        sync.Once
)

// Hash calculates the SHA1 checksum of a [20]byte, to provide for avalanching
// if you want small variances in the address to provide greater visual
// discontinuity.
//
// This intentionally uses a hashing algorithm with a 160 bit checksum (e.g.
// [20]byte), therefore the output remains the same size as the input and it can
// be represented similarly with momocode Vizs.
func Hash(address [20]byte) (checksum [20]byte) {
	return sha1.Sum(address[:])
}

// HexBytes is a convenience function to safely decode a hexadecimal string
// representation of an 20 byte address, as you will frequently see appear in
// non-typesafe languages.
//
// If you need more robust Ethereum address decoding (including handling
// soundness checksums), please use the go-ethereum library for this instead, in
// particular check out their common/hexutil package, etc.
func HexBytes(address string) ([20]byte, error) {
	dat, err := hex.DecodeString(strings.TrimPrefix(address, "0x"))
	if err != nil {
		return [20]byte{}, err
	}

	var res [20]byte
	if l := len(dat); l != 20 {
		err = fmt.Errorf("decoded %v bytes, expected 20", l)
	}
	// copy and return no matter what, if >20 bytes will be truncated
	copy(res[:], dat)
	return res, err
}
