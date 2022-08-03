// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../EmojiGame.sol";

import "forge-std/Test.sol";

contract EmojiGameTest is Test {
    EmojiGame emojiGame;

    function setUp() public {
        emojiGame = new EmojiGame();

        address addrr = 0x1234567890123456789012345678901234567890;
        emojiGame.safeMint(addrr);
    }

    function testMint() public {
        address addrr = 0x1234567890123456789012345678901234567890;
        address owner = emojiGame.ownerOf(0);
        assertEq(addrr, owner);
    }

    function testUri() public {
        (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,

        ) = emojiGame.emojiStats(0);

        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(checked, block.timestamp);
    }
}
