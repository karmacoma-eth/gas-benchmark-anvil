// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Counter} from "src/Counter.sol";

contract CounterScript is Script {
    string internal constant ANVIL_MNEMONIC = "test test test test test test test test test test test junk";

    // can deploy with
    //   forge script script/Counter.s.sol --rpc-url anvil --broadcast
    function run() public {
        string memory mnemonic = vm.envOr("MNEMONIC", ANVIL_MNEMONIC);
        uint256 deployerPK = vm.deriveKey(mnemonic, uint32(0));

        vm.broadcast(deployerPK);
        Counter counter = new Counter();

        // it may be useful to simulate other transactions with an address that is not the deployer/owner of the contract
        uint256 userPK = vm.deriveKey(mnemonic, uint32(1));
        vm.broadcast(userPK);

        counter.increment();
    }
}
