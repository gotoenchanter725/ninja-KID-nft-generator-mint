//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC721A.sol";

contract NFT_ERC721A is ERC721A, Ownable, Pausable {

    uint public constant MAX_SUPPLY = 10000;
    uint public constant PRICE = 0.05 ether;
    uint public constant MAX_PER_MINT = 10;

    string public _contractBaseURI;

    constructor(string memory baseURI) ERC721A("NFT_ERC721A", "ECR721A") {
        _contractBaseURI = baseURI;
        _pause();
    }


    function mint(uint256 quantity) external payable whenNotPaused {
        require(quantity > 0, "Quantity cannot be zero");
        uint totalMinted = totalSupply();
        require(quantity <= MAX_PER_MINT, "Cannot mint that many at once");
        require(totalMinted + quantity < MAX_SUPPLY, "Not enough NFTs left to mint");
        require(PRICE * quantity <= msg.value, "Insufficient funds sent");

        _safeMint(msg.sender, quantity);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;

        payable(msg.sender).transfer(balance);
    }

    function setBaseURI(string memory _newBaseURI) public {
        _contractBaseURI = _newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _contractBaseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_tokenId > 0 , "TokenID is invaliable");
        
        return string(abi.encodePacked(super.tokenURI(_tokenId), ".json"));
    }
}