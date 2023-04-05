pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface INFTMinter {
    function mint() external payable returns (uint256);
    function getPrice() external view returns (uint256);
    function getIPFSHash(uint256 _id) external view returns (string memory);
    function burn(uint256 _tokenId) external;
    function flipSaleStatus() external;
}

contract NFTMinter is ERC721, Ownable, INFTMinter {
    
    uint256 public totalSupply = 0;
    uint256 public price = 1000000000000000; // 0.001 ETH
    
    string private _baseURI;
    string private _ipfsBaseURI = "data:application/json;base64,";
    bytes32 private _hash;
    
    bool public saleIsActive = true;
    
    constructor() ERC721("NFTMinter", "NFTM") {}

    function mint() public payable override returns (uint256) {
        require(saleIsActive, "Minting is not currently available.");
        require(msg.value >= price, "Ether value sent is not correct.");

        uint256 newTokenId = totalSupply + 1;
        _safeMint(msg.sender, newTokenId);
        totalSupply++;

        _hash = keccak256(abi.encodePacked(_ipfsBaseURI, encodeTokenData(newTokenId)));

        _setTokenURI(newTokenId, string(abi.encodePacked(_baseURI, newTokenId.toString())));
        _setTokenURI(newTokenId, string(abi.encodePacked(_baseURI, newTokenId.toString())));

        price += 100000000000;
        return newTokenId;
    }

    function encodeTokenData(uint256 _tokenId) private view returns (bytes memory) {
        string memory _name = string(abi.encodePacked("My beautiful artwork #", uint2str(_tokenId)));
        string memory _hashStr = _hashToString(_hash);

        string memory json = string(abi.encodePacked('{"name":"', _name, '", "hash":"', _hashStr, '", "by":"', addressToString(owner()), '", "new owner":"', addressToString(msg.sender), '"}'));

        bytes memory encodedJson = bytes(json);
        bytes memory result = new bytes(_ipfsBaseURI.length + 44);
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < _ipfsBaseURI.length; i++) {
            result[resultIndex] = _ipfsBaseURI[i];
            resultIndex++;
        }

        bytes memory encodedJsonBase64 = bytes(base64Encode(encodedJson));

        for (uint256 i = 0; i < encodedJsonBase64.length; i++) {
            result[resultIndex] = encodedJsonBase64[i];
            resultIndex++;
        }

        return result;
    }

    function getIPFSHash(uint256 _id) public view override returns (string memory) {
        return _hashToString(_hash);
    }

    function getPrice() public view override returns (uint256) {
        return price;
    }

    function burn(uint256 _tokenId) public override {
        require(_exists(_tokenId), "Token does not exist.");
        require(ownerOf(_tokenId) == msg.sender, "Caller is not the owner.");
        _burn(_tokenId);
        totalSupply--;
        if (price > 1000000000000000) {
            price -= 100000000000;
            
