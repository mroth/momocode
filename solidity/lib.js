/*
For now, this is just a utility class to generate the data
payload for embedding in the contract.  In the future, someone
might want to replicate functionality in JS land.
*/
const EMOJIZ = "🌀🌂🌅🌈🌙🌞🌟🌠🌰🌱🌲🌳🌴🌵🌷🌸🌹🌺🌻🌼🌽🌾🌿🍀🍁🍂🍃🍄🍅\
🍆🍇🍈🍉🍊🍋🍌🍍🍎🍏🍐🍑🍒🍓🍔🍕🍖🍗🍘🍜🍝🍞🍟🍠🍡🍢🍣🍤🍥🍦🍧🍨🍩🍪🍫🍬🍭🍮🍯\
🍰🍱🍲🍳🍴🍵🍶🍷🍸🍹🍺🍻🍼🎀🎁🎂🎃🎄🎅🎈🎉🎊🎋🎌🎍🎎🎏🎒🎓🎠🎡🎢🎣🎤🎥🎦🎧🎨🎩\
🎪🎫🎬🎭🎮🎯🎰🎱🎲🎳🎴🎵🎷🎸🎹🎺🎻🎽🎾🎿🏀🏁🏂🏃🏄🏆🏇🏈🏉🏊🐀🐁🐂🐃🐄🐅🐆🐇🐈\
🐉🐊🐋🐌🐍🐎🐏🐐🐑🐒🐓🐔🐕🐖🐗🐘🐙🐚🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐨🐩🐪🐫🐬🐭🐮🐯\
🐰🐱🐲🐳🐴🐵🐶🐷🐸🐹🐺🐻🐼🐽🐾👀👂👃👄👅👆👇👈👉👊👋👌👍👎👏👐👑👒👓👔👕👖👗👘\
👙👚👛👜👝👞👟👠👡👢👣👤👥👦👧👨👩👪👮👯👺👻👼👽👾👿💀💁💂💃💄💅";

class EmojiCoder {
    constructor() {
        this.codingTable = Array.from(EMOJIZ);
    }

    static genHex() {
        const buf = Buffer.from(EMOJIZ, 'utf8');
        return buf.toString('hex');
    }

    // static encodeToString(bytes)   {}
    // static decodeFromString(coded) {}
    // etc...
};

module.exports = EmojiCoder;
