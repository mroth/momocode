package momocode_test

import (
	"fmt"

	momocode "github.com/mroth/momocode/go"
)

func ExampleEncode() {
	addr, _ := momocode.HexBytes("0x627306090abab3a6e1400e9345bc60c78a8bef57")
	fmt.Println(momocode.Encode(addr))
	// Output: 🎡🎲🌟🌱🌲🐱🐪🐝👚🍬🌷🐊🍱🐳🎓🐾🐁🐂👨🎈
}

func ExampleViz_Grid() {
	addr, _ := momocode.HexBytes("0x627306090abab3a6e1400e9345bc60c78a8bef57")
	fmt.Println(momocode.Encode(addr).Grid())
	// Output:
	// 🎡🎲🌟🌱🌲
	// 🐱🐪🐝👚🍬
	// 🌷🐊🍱🐳🎓
	// 🐾🐁🐂👨🎈
}

func ExampleHash() {
	addr1, _ := momocode.HexBytes("0x627306090abab3a6e1400e9345bc60c78a8bef57")
	addr2, _ := momocode.HexBytes("0x627306090abab3a6e1400e9345bc60c78a8bef58")
	fmt.Printf(
		"%v\n\n%v",
		momocode.Encode(momocode.Hash(addr1)).Grid(),
		momocode.Encode(momocode.Hash(addr2)).Grid(),
	)
	// Output:
	// 👈🐸🍶🐚🐮
	// 🎥🎰🐯🍀🐶
	// 🌷🐈🎊👇🏉
	// 🍭👾🎓🍍🐵
	//
	// 🍬👣👺🏃🐕
	// 🏃👦🍡👺🍻
	// 🐥💃🍘👒🌳
	// 🐌🐩🐆🐏👨
}
