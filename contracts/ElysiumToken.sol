// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ElysiumToken is ERC20, Ownable {
    address public devWallet;
    address public hypeRewardsWallet;
    address public liquidityWallet;

    uint256 public constant lpFee = 1;
    uint256 public constant devFee = 1;
    uint256 public constant hypeFee = 1;
    uint256 public constant totalFee = 3;

    mapping(address => bool) public isExcludedFromFee;

    constructor(
            address _devWallet, 
            address _hypeRewardsWallet, 
            address _liquidityWallet
    ) ERC20("Elysium Hype Token", "EHP") Ownable(msg.sender) {
        require(_devWallet != address(0), "Invalid dev wallet");
        require(_hypeRewardsWallet != address(0), "Invalid hype wallet");
        require(_liquidityWallet != address(0), "Invalid liquidity wallet");

        devWallet = _devWallet;
        hypeRewardsWallet = _hypeRewardsWallet;
        liquidityWallet = _liquidityWallet;

        isExcludedFromFee[msg.sender] = true;
        isExcludedFromFee[address(this)] = true;

        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function setWallets(
        address _devWallet, 
        address _hypeRewardsWallet, 
        address _liquidityWallet
    ) external onlyOwner {
        devWallet = _devWallet;
        hypeRewardsWallet = _hypeRewardsWallet;
        liquidityWallet = _liquidityWallet;
    }

    function setExcludedFromFee(address account, bool excluded) external onlyOwner {
        isExcludedFromFee[account] = excluded;
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override {
        if (from == address(0) || to == address(0) || isExcludedFromFee[from] || isExcludedFromFee[to]) {
            super._update(from, to, value);
            return;
        }

        uint256 feeAmount = (value * totalFee) / 100;
        uint256 transferAmount = value - feeAmount;

        uint256 devAmount = (value * devFee) / 100;
        uint256 hypeAmount = (value * hypeFee) / 100;
        uint256 lpAmount = feeAmount - devAmount - hypeAmount;

        if (devAmount > 0) {
            super._update(from, devWallet, devAmount);
        }
        if (hypeAmount > 0) {
            super._update(from, hypeRewardsWallet, hypeAmount);
        }
        if (lpAmount > 0) {
            super._update(from, liquidityWallet, lpAmount);
        }

        super._update(from, to, transferAmount);
    }
}

