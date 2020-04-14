package momocode

import (
	"reflect"
	"testing"
)

var samplecases = []struct {
	name string
	hex  [20]byte
	viz  Viz
}{
	{
		name: "sample1",
		hex: [20]byte{
			0x58, 0x30, 0x31, 0xd1, 0x11,
			0x3a, 0xd4, 0x14, 0xf0, 0x25,
			0x76, 0xbd, 0x6a, 0xfa, 0xbf,
			0xb3, 0x02, 0x14, 0x02, 0x25,
		},
		viz: [20]rune{
			'🎉', '🍜', '🍝', '👊', '🌺',
			'🍦', '👍', '🌽', '👩', '🍎',
			'🎵', '🐴', '🎩', '💀', '🐶',
			'🐪', '🌅', '🌽', '🌅', '🍎',
		},
	},
	{
		name: "sample2",
		// 627306090abab3a6e1400e9345bc60c78a8bef57
		hex: [20]byte{
			0x62, 0x73, 0x06, 0x09, 0x0a,
			0xba, 0xb3, 0xa6, 0xe1, 0x40,
			0x0e, 0x93, 0x45, 0xbc, 0x60,
			0xc7, 0x8a, 0x8b, 0xef, 0x57,
		},
		viz: Viz{
			'🎡', '🎲', '🌟', '🌱', '🌲',
			'🐱', '🐪', '🐝', '👚', '🍬',
			'🌷', '🐊', '🍱', '🐳', '🎓',
			'🐾', '🐁', '🐂', '👨', '🎈',
		},
	},
}

func TestEncode(t *testing.T) {
	for _, tt := range samplecases {
		t.Run(tt.name, func(t *testing.T) {
			if got := Encode(tt.hex); got != tt.viz {
				t.Errorf("Encode() = %v, want %v", got, tt.viz)
			}
		})
	}
}

func TestDecode(t *testing.T) {
	// sample cases should decode successfully
	for _, tt := range samplecases {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Decode(tt.viz)
			if err != nil {
				t.Fatal(err)
			}
			if got != tt.hex {
				t.Errorf("Decode() = 0x%x, want 0x%x", got, tt.hex)
			}
		})
	}

	// viz with invalid emoji glyphs should generate an error
	t.Run("invalid glyphs", func(t *testing.T) {
		// same as sample2, but with 5th emoji swapped for something invalid
		invalid := Viz{
			'🎡', '🎲', '🌟', '🌱', '🔕',
			'🐱', '🐪', '🐝', '👚', '🍬',
			'🌷', '🐊', '🍱', '🐳', '🎓',
			'🐾', '🐁', '🐂', '👨', '🎈',
		}
		res, err := Decode(invalid)
		// we should get an error
		if err != ErrInvalidRune {
			t.Errorf("want error: %v, got %v", ErrInvalidRune, err)
		}
		// result contains all valid data up til the first invalid glyph
		expect := [20]byte{
			0x62, 0x73, 0x06, 0x09, 0x0,
			0x0, 0x0, 0x0, 0x0, 0x0,
			0x0, 0x0, 0x0, 0x0, 0x0,
			0x0, 0x0, 0x0, 0x0, 0x0,
		}
		if res != expect {
			t.Errorf("want 0x%x, got 0x%x", expect, res)
		}
	})
}

func BenchmarkEncode(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Encode(samplecases[0].hex)
	}
}

func BenchmarkDecode(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Decode(samplecases[0].viz)
	}
}

func TestHexBytes(t *testing.T) {
	tests := []struct {
		name    string
		address string
		want    [20]byte
		wantErr bool
	}{
		{
			name:    "with prefix",
			address: "0x583031d1113ad414f02576bd6afabfb302140225",
			want: [20]byte{
				0x58, 0x30, 0x31, 0xd1, 0x11,
				0x3a, 0xd4, 0x14, 0xf0, 0x25,
				0x76, 0xbd, 0x6a, 0xfa, 0xbf,
				0xb3, 0x02, 0x14, 0x02, 0x25},
			wantErr: false,
		},
		{
			name:    "without prefix",
			address: "583031d1113ad414f02576bd6afabfb302140225",
			want: [20]byte{
				0x58, 0x30, 0x31, 0xd1, 0x11,
				0x3a, 0xd4, 0x14, 0xf0, 0x25,
				0x76, 0xbd, 0x6a, 0xfa, 0xbf,
				0xb3, 0x02, 0x14, 0x02, 0x25},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := HexBytes(tt.address)
			if (err != nil) != tt.wantErr {
				t.Errorf("HexBytes() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("HexBytes() = %#v, want %#v", got, tt.want)
			}
		})
	}
}
