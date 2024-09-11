// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public USER = makeAddr("user");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        assertEq(expectedName, actualName);
        // Hashed string comparison
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();
        assertEq(expectedSymbol, actualSymbol);
        // Hashed string comparison
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }
    
    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(basicNft.ownerOf(0), USER);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    // function testCanMintMultipleNfts() public {
    //     vm.prank(USER);
    //     basicNft.mintNft(PUG);
    //     basicNft.mintNft(PUG);
    //     assertEq(basicNft.balanceOf(USER), 2);
    //     assertEq(basicNft.ownerOf(0), USER);
    //     assertEq(basicNft.ownerOf(1), USER);
    // }

    function testCanTransferNft() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        address recipient = makeAddr("recipient");
        vm.prank(USER);
        basicNft.transferFrom(USER, recipient, 0);
        assertEq(basicNft.balanceOf(USER), 0);
        assertEq(basicNft.balanceOf(recipient), 1);
        assertEq(basicNft.ownerOf(0), recipient);
    }

    function testApprovalAndTransferFrom() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        address recipient = makeAddr("recipient");
        vm.prank(USER);
        basicNft.approve(recipient, 0);
        vm.prank(recipient);
        basicNft.transferFrom(USER, recipient, 0);
        assertEq(basicNft.balanceOf(USER), 0);
        assertEq(basicNft.balanceOf(recipient), 1);
        assertEq(basicNft.ownerOf(0), recipient);
    }

    function testRevertOnInvalidTransfer() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        address nonOwner = makeAddr("nonOwner");
        vm.expectRevert();
        vm.prank(nonOwner);
        basicNft.transferFrom(USER, nonOwner, 0);
    }

    function testTokenUri() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        assertEq(basicNft.tokenURI(0), PUG);
    }
}
