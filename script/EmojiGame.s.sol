// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/EmojiGame.sol";
import "./HelperConfig.sol";

contract DeployEmojiGame is Script {
    function run() external {
        vm.startBroadcast();

        new EmojiGame();

        vm.stopBroadcast();
    }
}
