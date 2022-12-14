// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

contract EmojiGame is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string SVGBase =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIHZpZXdCb3g9JzAgMCA4MDAgODAwJz48cmVjdCBmaWxsPScjZmZmZmZmJyB3aWR0aD0nODAwJyBoZWlnaHQ9JzgwMCcvPjxkZWZzPjxyYWRpYWxHcmFkaWVudCBpZD0nYScgY3g9JzQwMCcgY3k9JzQwMCcgcj0nNTAuMSUnIGdyYWRpZW50VW5pdHM9J3VzZXJTcGFjZU9uVXNlJz48c3RvcCAgb2Zmc2V0PScwJyBzdG9wLWNvbG9yPScjZmZmZmZmJy8+PHN0b3AgIG9mZnNldD0nMScgc3RvcC1jb2xvcj0nIzBFRicvPjwvcmFkaWFsR3JhZGllbnQ+PHJhZGlhbEdyYWRpZW50IGlkPSdiJyBjeD0nNDAwJyBjeT0nNDAwJyByPSc1MC40JScgZ3JhZGllbnRVbml0cz0ndXNlclNwYWNlT25Vc2UnPjxzdG9wICBvZmZzZXQ9JzAnIHN0b3AtY29sb3I9JyNmZmZmZmYnLz48c3RvcCAgb2Zmc2V0PScxJyBzdG9wLWNvbG9yPScjMEZGJy8+PC9yYWRpYWxHcmFkaWVudD48L2RlZnM+PHJlY3QgZmlsbD0ndXJsKCNhKScgd2lkdGg9JzgwMCcgaGVpZ2h0PSc4MDAnLz48ZyBmaWxsLW9wYWNpdHk9JzAuNSc+PHBhdGggZmlsbD0ndXJsKCNiKScgZD0nTTk5OC43IDQzOS4yYzEuNy0yNi41IDEuNy01Mi43IDAuMS03OC41TDQwMSAzOTkuOWMwIDAgMC0wLjEgMC0wLjFsNTg3LjYtMTE2LjljLTUuMS0yNS45LTExLjktNTEuMi0yMC4zLTc1LjhMNDAwLjkgMzk5LjdjMCAwIDAtMC4xIDAtMC4xbDUzNy4zLTI2NWMtMTEuNi0yMy41LTI0LjgtNDYuMi0zOS4zLTY3LjlMNDAwLjggMzk5LjVjMCAwIDAtMC4xLTAuMS0wLjFsNDUwLjQtMzk1Yy0xNy4zLTE5LjctMzUuOC0zOC4yLTU1LjUtNTUuNWwtMzk1IDQ1MC40YzAgMC0wLjEgMC0wLjEtMC4xTDczMy40LTk5Yy0yMS43LTE0LjUtNDQuNC0yNy42LTY4LTM5LjNsLTI2NSA1MzcuNGMwIDAtMC4xIDAtMC4xIDBsMTkyLjYtNTY3LjRjLTI0LjYtOC4zLTQ5LjktMTUuMS03NS44LTIwLjJMNDAwLjIgMzk5YzAgMC0wLjEgMC0wLjEgMGwzOS4yLTU5Ny43Yy0yNi41LTEuNy01Mi43LTEuNy03OC41LTAuMUwzOTkuOSAzOTljMCAwLTAuMSAwLTAuMSAwTDI4Mi45LTE4OC42Yy0yNS45IDUuMS01MS4yIDExLjktNzUuOCAyMC4zbDE5Mi42IDU2Ny40YzAgMC0wLjEgMC0wLjEgMGwtMjY1LTUzNy4zYy0yMy41IDExLjYtNDYuMiAyNC44LTY3LjkgMzkuM2wzMzIuOCA0OTguMWMwIDAtMC4xIDAtMC4xIDAuMUw0LjQtNTEuMUMtMTUuMy0zMy45LTMzLjgtMTUuMy01MS4xIDQuNGw0NTAuNCAzOTVjMCAwIDAgMC4xLTAuMSAwLjFMLTk5IDY2LjZjLTE0LjUgMjEuNy0yNy42IDQ0LjQtMzkuMyA2OGw1MzcuNCAyNjVjMCAwIDAgMC4xIDAgMC4xbC01NjcuNC0xOTIuNmMtOC4zIDI0LjYtMTUuMSA0OS45LTIwLjIgNzUuOEwzOTkgMzk5LjhjMCAwIDAgMC4xIDAgMC4xbC01OTcuNy0zOS4yYy0xLjcgMjYuNS0xLjcgNTIuNy0wLjEgNzguNUwzOTkgNDAwLjFjMCAwIDAgMC4xIDAgMC4xbC01ODcuNiAxMTYuOWM1LjEgMjUuOSAxMS45IDUxLjIgMjAuMyA3NS44bDU2Ny40LTE5Mi42YzAgMCAwIDAuMSAwIDAuMWwtNTM3LjMgMjY1YzExLjYgMjMuNSAyNC44IDQ2LjIgMzkuMyA2Ny45bDQ5OC4xLTMzMi44YzAgMCAwIDAuMSAwLjEgMC4xbC00NTAuNCAzOTVjMTcuMyAxOS43IDM1LjggMzguMiA1NS41IDU1LjVsMzk1LTQ1MC40YzAgMCAwLjEgMCAwLjEgMC4xTDY2LjYgODk5YzIxLjcgMTQuNSA0NC40IDI3LjYgNjggMzkuM2wyNjUtNTM3LjRjMCAwIDAuMSAwIDAuMSAwTDIwNy4xIDk2OC4zYzI0LjYgOC4zIDQ5LjkgMTUuMSA3NS44IDIwLjJMMzk5LjggNDAxYzAgMCAwLjEgMCAwLjEgMGwtMzkuMiA1OTcuN2MyNi41IDEuNyA1Mi43IDEuNyA3OC41IDAuMUw0MDAuMSA0MDFjMCAwIDAuMSAwIDAuMSAwbDExNi45IDU4Ny42YzI1LjktNS4xIDUxLjItMTEuOSA3NS44LTIwLjNMNDAwLjMgNDAwLjljMCAwIDAuMSAwIDAuMSAwbDI2NSA1MzcuM2MyMy41LTExLjYgNDYuMi0yNC44IDY3LjktMzkuM0w0MDAuNSA0MDAuOGMwIDAgMC4xIDAgMC4xLTAuMWwzOTUgNDUwLjRjMTkuNy0xNy4zIDM4LjItMzUuOCA1NS41LTU1LjVsLTQ1MC40LTM5NWMwIDAgMC0wLjEgMC4xLTAuMUw4OTkgNzMzLjRjMTQuNS0yMS43IDI3LjYtNDQuNCAzOS4zLTY4bC01MzcuNC0yNjVjMCAwIDAtMC4xIDAtMC4xbDU2Ny40IDE5Mi42YzguMy0yNC42IDE1LjEtNDkuOSAyMC4yLTc1LjhMNDAxIDQwMC4yYzAgMCAwLTAuMSAwLTAuMUw5OTguNyA0MzkuMnonLz48L2c+PHRleHQgeD0nNTAlJyB5PSc1MCUnIGNsYXNzPSdiYXNlJyBkb21pbmFudC1iYXNlbGluZT0nbWlkZGxlJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBmb250LXNpemU9JzhlbSc+8J+";

    string[] emojiBase64 = [
        "kqTwvdGV4dD48L3N2Zz4=",
        "YgTwvdGV4dD48L3N2Zz4=",
        "YkDwvdGV4dD48L3N2Zz4=",
        "YoTwvdGV4dD48L3N2Zz4=",
        "SgDwvdGV4dD48L3N2Zz4="
    ];

    struct EmojiAttributes {
        uint256 emojiIndex;
        uint256 happiness;
        uint256 hunger;
        uint256 enrichment;
        uint256 lastChecked;
        string imageURI;
    }

    event EmojiUpdated(
        uint256 happiness,
        uint256 hunger,
        uint256 enrichment,
        uint256 checked,
        string uri,
        uint256 index
    );

    mapping(address => uint256) public emojiHolders;
    mapping(uint256 => EmojiAttributes) public emojiHolderAttributes;

    constructor() ERC721("Emoji", "EMJ") {}

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        string memory finalSVG = string(
            abi.encodePacked(SVGBase, emojiBase64[0])
        );
        emojiHolderAttributes[tokenId] = EmojiAttributes({
            emojiIndex: tokenId,
            happiness: 100,
            hunger: 100,
            enrichment: 100,
            lastChecked: block.timestamp,
            imageURI: finalSVG
        });
        emojiHolders[msg.sender] = tokenId;

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        EmojiAttributes memory emojiAttributes = emojiHolderAttributes[tokenId];
        string memory strHappieness = Strings.toString(
            emojiAttributes.happiness
        );
        string memory strHunger = Strings.toString(emojiAttributes.hunger);
        string memory strEnrichment = Strings.toString(
            emojiAttributes.enrichment
        );

        string memory json = string(
            abi.encodePacked(
                '{"name": "Your little Friend",',
                '"description: "Keep your friend happy",',
                '"image":"',
                emojiAttributes.imageURI,
                '",',
                '"traits": [',
                '{"trait_type": "Hunger", "value": ',
                strHunger,
                "},",
                '{"trait_type": "Happiness", "value": ',
                strHappieness,
                "},",
                '{"trait_type": "Enrichment", "value": ',
                strEnrichment,
                "}",
                "]}"
            )
        );
        return json;
    }

    function emojiStats(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return (
            emojiHolderAttributes[tokenId].happiness,
            emojiHolderAttributes[tokenId].hunger,
            emojiHolderAttributes[tokenId].enrichment,
            emojiHolderAttributes[tokenId].lastChecked,
            emojiHolderAttributes[tokenId].imageURI
        );
    }

    function myEmoji()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return emojiStats(emojiHolders[msg.sender]);
    }

    function passTime(uint256 tokenId) public {
        if (emojiHolderAttributes[tokenId].hunger > 10) {
            emojiHolderAttributes[tokenId].hunger -= 10;
        }
        if (emojiHolderAttributes[tokenId].enrichment > 10) {
            emojiHolderAttributes[tokenId].enrichment -= 10;
        }
        emojiHolderAttributes[tokenId].happiness =
            (emojiHolderAttributes[tokenId].hunger +
                emojiHolderAttributes[tokenId].enrichment) /
            2;
        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    function updateURI(uint256 tokenId) private {
        string memory emojiB64 = emojiBase64[0];
        if (emojiHolderAttributes[tokenId].happiness == 100) {
            emojiB64 = emojiBase64[0];
        } else if (emojiHolderAttributes[tokenId].happiness > 66) {
            emojiB64 = emojiBase64[1];
        } else if (emojiHolderAttributes[tokenId].happiness > 33) {
            emojiB64 = emojiBase64[2];
        } else if (emojiHolderAttributes[tokenId].happiness > 0) {
            emojiB64 = emojiBase64[3];
        } else {
            emojiB64 = emojiBase64[4];
        }

        string memory finalSVG = string(abi.encodePacked(SVGBase, emojiB64));
        emojiHolderAttributes[tokenId].imageURI = finalSVG;
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function feed() public {
        uint256 tokenId = emojiHolders[msg.sender];
        emojiHolderAttributes[tokenId].hunger += 10;
        emojiHolderAttributes[tokenId].happiness =
            (emojiHolderAttributes[tokenId].hunger +
                emojiHolderAttributes[tokenId].enrichment) /
            2;
        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    function play() public {
        uint256 tokenId = emojiHolders[msg.sender];
        emojiHolderAttributes[tokenId].enrichment += 10;
        emojiHolderAttributes[tokenId].happiness =
            (emojiHolderAttributes[tokenId].hunger +
                emojiHolderAttributes[tokenId].enrichment) /
            2;
        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    /**
     * @notice Checks if the contract requires work to be done
     */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory performData) {
        uint256 lastTimeStamp = emojiHolderAttributes[0].lastChecked;
        upkeepNeeded =
            (block.timestamp - lastTimeStamp) > 60 &&
            emojiHolderAttributes[0].happiness > 0;
        performData = bytes("");
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    /**
     * @notice Performs the work on the contract, if instructed by :checkUpkeep():
     */
    function performUpkeep(
        bytes calldata /* performData */
    ) external {
        // add some verification
        uint256 lastTimeStamp = emojiHolderAttributes[0].lastChecked;
        (bool upkeepNeeded, ) = checkUpkeep("");
        require(upkeepNeeded, "Time interval not met");

        emojiHolderAttributes[0].lastChecked = block.timestamp;
        passTime(0);
        // We don't use the performData in this example.
        // The performData is generated by the Keeper's call to your checkUpkeep function
    }

    function emitUpdate(uint256 tokenId) internal {
        emit EmojiUpdated(
            emojiHolderAttributes[tokenId].happiness,
            emojiHolderAttributes[tokenId].hunger,
            emojiHolderAttributes[tokenId].enrichment,
            emojiHolderAttributes[tokenId].lastChecked,
            emojiHolderAttributes[tokenId].imageURI,
            tokenId
        );
    }
}
