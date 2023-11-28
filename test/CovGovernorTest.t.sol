// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {CoVGovernor} from "../src/CoVGovernor.sol";
import {Box} from "../src/Box.sol";
import {Timelock} from "../src/Timelock.sol";
import {CoVDAO} from "../src/CovNFTDAO.sol";

contract MyGovernorTest is Test {
    CoVGovernor governor;
    Box box;
    Timelock timelock;
    CoVDAO govToken;

    address public USER = makeAddr("user");
    // uint256 public constant INITIAL_SUPPLY = 100 ether;
    string public constant TOKEN_URI =
        "bafkreia7x3u3wzcbeviiigw4c5blmypx3lpmieynlhe5qwao5lu5jls3gm";

    uint256 public constant MIN_DELAY = 3600;
    uint256 public constant VOTING_DELAY = 2; // how many blocks the proposal is active
    uint256 public constant VOTING_PERIOD = 25; // how many seconds the proposal is active

    address[] proposers;
    address[] executors;
    address[] admins = [USER];

    uint256[] values = [0];
    bytes[] calldatas;
    address[] targets;

    function setUp() public {
        govToken = new CoVDAO(USER, USER, USER);
        vm.startPrank(USER);

        bytes32 minterRole = govToken.MINTER_ROLE();
        govToken.grantRole(minterRole, address(0));

        govToken.safeMint(USER, TOKEN_URI);

        govToken.delegate(USER);
        timelock = new Timelock(MIN_DELAY, proposers, executors, admins);
        governor = new CoVGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);

        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock));
    }

    function testFailCantUpdateBoxWithoutGovernance(uint256 _value) public {
        // vm.expectRevert();
        box.store(_value);
    }

    function testGovernanceUpdateBox(uint256 _value) public {
        uint256 valueToStore = _value;
        string memory description = "store 111 in Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "store(uint256)",
            valueToStore
        );
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));

        // 1. Propose to the DAO
        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            description
        );

        // View the state
        console.log("Proposal State: ", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        console.log("Proposal State: ", uint256(governor.state(proposalId)));

        // 2. Vote
        string memory reason = "cuz blue frog is cool";
        uint8 voteWay = 1; // voting yes

        vm.prank(USER);
        governor.castVoteWithReason(proposalId, voteWay, reason);
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        // 3. Queue
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        vm.roll(block.number + MIN_DELAY + 1);

        // 4. Execute
        governor.execute(targets, values, calldatas, descriptionHash);

        // 5. Check if the value is updated
        uint256 storedValue = box.getNumber();
        assertEq(storedValue, valueToStore);
        console.log("Stored Values changed to ", storedValue);
        console.log("Proposal State", uint256(governor.state(proposalId)));
    }
}
