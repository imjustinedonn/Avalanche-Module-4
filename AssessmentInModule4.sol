// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AssessmentInModule4 is ERC20 {

    address public OwnerAccountWallet;

    constructor() ERC20("Degen", "DGN") {
        OwnerAccountWallet = msg.sender;
    }

    string[] DegenItems = ["Selection 1: Paymaya", "Selection 2: Gcash", "Selection 3: Paypal"];

    mapping (address => uint) public MoneyBalance;
    mapping(address => mapping(string => uint256)) public MoneyAdded;

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

    function DGNAvailableItem() public view returns (string memory, string memory, string memory) {
        return (DegenItems[0], DegenItems[1], DegenItems[2]);
    }

    function Redeeming(address AccountWallet, uint256 choose) public {
        if (choose == 1) {
            require(MoneyBalance[AccountWallet] >= 1500, "DGN Token in account is insufficient");
            MoneyBalance[AccountWallet] -= 1500;
            MoneyAdded[AccountWallet]["Paymaya"] += 1485;
        } else if (choose == 2) {
            require(MoneyBalance[AccountWallet] >= 3000, "DGN Token in account is insufficient");
            MoneyBalance[AccountWallet] -= 3000;
            MoneyAdded[AccountWallet]["Gcash"] += 2985;
        } else if (choose == 3) {
            require(MoneyBalance[AccountWallet] >= 5000, "DGN Token in account is insufficient");
            MoneyBalance[AccountWallet] -= 5000;
            MoneyAdded[AccountWallet]["Paypal"] += 4985;
        } else {
            revert("Item not found, Choose 1, 2, 3 only!");
        }
    }
}
