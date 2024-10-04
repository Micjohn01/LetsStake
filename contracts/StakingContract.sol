// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StakingContract {
    struct Stake {
        uint256 amount;
        uint256 since;
    }

    mapping(address => Stake) public stakes;
    uint256 public totalStaked;
    uint256 public rewardRate = 10; // 10% per year

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);

    function stake() public payable {
        require(msg.value > 0, "Cannot stake 0");
        if (stakes[msg.sender].amount > 0) {
            uint256 reward = calculateReward(msg.sender);
            stakes[msg.sender].amount += reward;
        }
        stakes[msg.sender].amount += msg.value;
        stakes[msg.sender].since = block.timestamp;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function unstake(uint256 amount) public {
        require(stakes[msg.sender].amount >= amount, "Insufficient stake");
        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmount = amount + reward;
        stakes[msg.sender].amount -= amount;
        totalStaked -= amount;
        if (stakes[msg.sender].amount > 0) {
            stakes[msg.sender].since = block.timestamp;
        } else {
            delete stakes[msg.sender];
        }
        payable(msg.sender).transfer(totalAmount);
        emit Unstaked(msg.sender, amount, reward);
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 stakedTime = block.timestamp - stakes[user].since;
        return (stakes[user].amount * rewardRate * stakedTime) / (365 days * 100);
    }

    function getStakeInfo(address user) public view returns (uint256 amount, uint256 reward) {
        amount = stakes[user].amount;
        reward = calculateReward(user);
    }
}