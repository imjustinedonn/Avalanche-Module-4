// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AssessmentInModule4 is ERC20 {

    address public OwnerAccountWallet;

    constructor() ERC20("Degen", "DGN") {
        OwnerAccountWallet = msg.sender;
    }

    string[] DegenItems = [
        "AVAILABLE ITEMS IN STORE:", 
        "EMERALD" ,
        "DIAMOND" , 
        "PLATINUM" , 
        "----------------------" , 
        "Equivalent Degen Token:" , 
        "1 EMERALD = 100 DGN" , 
        "1 DIAMOND = 500 DGN" , 
        "1 PLATINUM = 1000 DGN"
        ];

    mapping (address WalletAccount => uint DGN) public MoneyBalance;
    mapping(address WalletAccount=> mapping(string Items=> uint256 StoredAmount)) public RedeemedDegen;

    function Minting(address AccountWallet, uint256 DGN) public {
        require(msg.sender == OwnerAccountWallet, "Owner ownly have an access");
        _mint(AccountWallet, DGN);
        MoneyBalance[AccountWallet] += DGN;
    }

    function Burning(address AccountWallet, uint256 DGN) public {
        require(MoneyBalance[AccountWallet] >= DGN, "There aren't enough DGN Token in your account to burn");
        _burn(AccountWallet, DGN);
        MoneyBalance[AccountWallet] -= DGN;
    }

    function Transferring(address spender, address receiver, uint256 DGN) public {
        require(MoneyBalance[spender] >= DGN, "Not enough DGN Tokens in the account to send");
        _approve(spender, receiver, DGN);
        _transfer(spender, receiver, DGN);

        MoneyBalance[spender] -= DGN;
        MoneyBalance[receiver] += DGN;
    }

    function DGNAvailableItem() public view returns (
        string memory, string memory, string memory, string memory, 
        string memory, string memory , string memory, string memory ,string memory) 
        {
        return (
            DegenItems[0], DegenItems[1], DegenItems[2], DegenItems[3], 
            DegenItems[4], DegenItems[5], DegenItems[6], DegenItems[7], DegenItems[8]
            );
    }

    function RedeemDegenToMoney(address AccountWallet, string memory ItemsChoosen, uint256 ItemsAmount) public {
        uint256 degenamount;

        if (keccak256(abi.encodePacked(DegenItems[1])) == keccak256(abi.encodePacked(ItemsChoosen))) {
            degenamount = 100;
        } else if (keccak256(abi.encodePacked(DegenItems[2])) == keccak256(abi.encodePacked(ItemsChoosen))) {
            degenamount = 500;
        } else if (keccak256(abi.encodePacked(DegenItems[3])) == keccak256(abi.encodePacked(ItemsChoosen))) {
            degenamount = 1000;
        } else {
            revert("Item not found, Only EMERALD, DIAMOND & PLATINUM are currently available!");
        }

        uint256 total = ItemsAmount * degenamount;
        require(MoneyBalance[AccountWallet] >= total, "DGN Token in account is insufficient");
        
        MoneyBalance[AccountWallet] -= total;
        RedeemedDegen[AccountWallet][ItemsChoosen] += ItemsAmount;
    }
}
