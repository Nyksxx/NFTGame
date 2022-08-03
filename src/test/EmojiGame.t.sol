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

    function testMyEmoji() public {
        (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,

        ) = emojiGame.myEmoji();

        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(checked, block.timestamp);
    }

    function testPassTime() public {
        emojiGame.passTime(0);
        (uint256 happiness, uint256 hunger, uint256 enrichment, , ) = emojiGame
            .emojiStats(0);

        assertEq(hunger, 90);
        assertEq(enrichment, 90);
        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(happiness, (90 + 90) / 2);
    }

    function testFeed() public {
        emojiGame.passTime(0);
        emojiGame.feed();
        (uint256 happiness, uint256 hunger, , , ) = emojiGame.myEmoji();
        assertEq(hunger, 100);
        assertEq(happiness, (100 + 90) / 2);
    }

    function testPlay() public {
        emojiGame.passTime(0);
        emojiGame.play();
        (uint256 happiness, , uint256 enrichment, , ) = emojiGame.myEmoji();
        assertEq(enrichment, 100);
        assertEq(happiness, (90 + 100) / 2);
    }
}
