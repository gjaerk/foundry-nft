// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNftTest is Script {
    DeployMoodNft public deployer;

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");
        
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(sadSvg),
            svgToImageURI(happySvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function setUp() public {
        deployer = new DeployMoodNft();
        // moodNft = deployer.run();
    }

    function testConvertSvgToUri() public view {
        string memory extepectedUri = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj48dGV4dCB4PSIwIiB5PSIxNSIgZmlsbD0iYmxhY2siPkhpISBZb3VyIGJyb3dzZXIgZGVjb2RlZCB0aGlzITwvdGV4dD48L3N2Zz4=";
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15" fill="black">Hi! Your browser decoded this!</text></svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        console.log("Actual URI:", actualUri);
        console.log("Expected URI:", extepectedUri);
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(extepectedUri)));
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

}