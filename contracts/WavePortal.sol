// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint totalWaves;
  uint private seed;

  event NewWave(address indexed from, uint timestamp, string message);

  struct wavers {
    uint nbOfWaves;
    Wave[] waves;
  }

  struct Wave {
    address waver;
    string message;
    uint timestamp;
  }

  Wave[] waves;

  mapping (address => wavers) waversInfo;
  constructor() payable {
    console.log("Yeah");
  }

  function wave(string memory _message) public {
    uint userWavesCount = waversInfo[msg.sender].waves.length;
    require((userWavesCount == 0 ) || (waversInfo[msg.sender].waves[userWavesCount-1].timestamp + 30 seconds < block.timestamp), "wait 30 seconds");
    totalWaves += 1;
    waversInfo[msg.sender].nbOfWaves++;
    waversInfo[msg.sender].waves.push(Wave(msg.sender, _message, block.timestamp));
    console.log("%s waved w/ message %s", msg.sender, _message);
    waves.push(Wave(msg.sender, _message, block.timestamp));
    emit NewWave(msg.sender, block.timestamp, _message);

    uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random # generated: %s", randomNumber);

    seed = randomNumber;

    if(randomNumber < 40) {
      console.log("%s won!", msg.sender);
      uint prizeAmount = 0.0001 ether;
      require(prizeAmount <= address(this).balance, "Not enough fund.");
      (bool success,) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money from contract.");
    }
  }

  function getTotalWaves() view public returns (uint) {
    console.log("We have %d total waves", totalWaves);
    return totalWaves;
  }

  function getAllWaves() view public returns (Wave[] memory) {
    return waves;
  }

  function getTotalWavesByUser() view public returns (uint) {
    console.log("%s has waived %d times", msg.sender, waversInfo[msg.sender].nbOfWaves);
    return waversInfo[msg.sender].nbOfWaves;
  }

  function whenUserWavedFirstTime() view public returns (uint) {
    console.log("%s has waived the first time the %d", msg.sender, waversInfo[msg.sender].waves[0].timestamp);
    return waversInfo[msg.sender].waves[0].timestamp;
  }

  function getWaversData() view public returns (Wave[] memory) {
    return waversInfo[msg.sender].waves;
  }
}