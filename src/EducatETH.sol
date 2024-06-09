// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "./ERC1155.sol";

contract EducatETH is ERC1155 {
    string public name = "EducatETH NFT";
    string public symbol = "EEN";
    string public constant baseURI = "https://ipfs.io/ipfs/QmSuQaSxg4kbmN8N6KwnNyvYNzDNiu7gx1AfNeeN384q5F";

    constructor(address owner) {
        mint(owner, 1, 1);  // Mintea un NFT con id 1 y cantidad 1 al creador del contrato
    }

    function uri(uint256 id) public pure override returns (string memory) {
        return baseURI;
    }

    function mint(address to, uint256 id, uint256 amount) public {
        _mint(to, id, amount, "");
        emit URI(baseURI, id);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) public {
        _batchMint(to, ids, amounts, "");
        for (uint256 i = 0; i < ids.length; i++) {
            emit URI(baseURI, ids[i]);
        }
    }
}
