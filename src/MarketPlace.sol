// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

import "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";



contract Marketplace is ReentrancyGuard {

    // Variables
    uint public itemCount; 
    bytes SignatureChecker;
    address public owner;
      address payable public immutable feeAccount; // the account that receives fees
    uint public immutable feePercent;

    struct Item {
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint price;
        address payable seller;
        uint duration;
        bool isActive;
    }

    // itemId -> Item
    mapping(uint => Item) public items;

    event Listed(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        uint duration,
        address indexed seller,
        bool isActive
    );
    event Bought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer
    );
      
      constructor(uint _feePercent) {
          msg.sender == owner;
         feeAccount = payable(msg.sender);
        feePercent = _feePercent;
      }
    // Make item to offer on the marketplace
    function listItem(address _nft, uint _tokenId, uint _price, uint _duration) external nonReentrant {
        require(_price > 0, "Price must be greater than zero");
        require (_nft != address(0));
        require(msg.sender != address(0));
        require(_duration > block.timestamp);
        // increment itemCount
        itemCount ++;
        // transfer nft
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        // add new item to items mapping
        items[itemCount] = Item (
            itemCount,
            _nft,
            _tokenId,
            _price,
            _duration,
            payable(msg.sender),
            false
        );
        // emit Offered event
        emit Listed(
            itemCount,
            address(_nft),
            _tokenId,
            _price,
            _duration,
            msg.sender,
            true
        );
    }

    function purchaseListed(uint _itemId) external payable nonReentrant {
        uint _totalPrice = getTotalPrice(_itemId);
        Item storage item = items[_itemId];
        require(_itemId > 0 && _itemId <= itemCount, "item doesn't exist");
        require(msg.value >= _totalPrice, "not enough ether to cover item price and market fee");
        require(!item.sold, "item already sold");
        // pay seller and feeAccount
        item.seller.transfer(item.price);
        feeAccount.transfer(_totalPrice - item.price);
        // update item to sold
        item.sold = true;
        // transfer nft to buyer
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);
        // emit Bought event
        emit Bought(
            _itemId,
            address(item.nft),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    }
    function getTotalPrice(uint _itemId) view public returns(uint){
        return((items[_itemId].price*(100 + feePercent))/100);
    }
}



