// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpsonsToken is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18;
    uint256 public constant TAX_FEE = 2; // 2% Gesamtgebühr (1% Dev, 1% Burn)
    address public devWallet;

    mapping(address => bool) private _isExcludedFromFee;

    constructor(address initialOwner, address initialDevWallet) 
        ERC20("The Simpsonss", "SIMPSONSS") 
        Ownable(initialOwner) 
    {
        require(initialDevWallet != address(0), "Ungueltige Dev-Adresse");
        devWallet = initialDevWallet;

        _isExcludedFromFee[initialOwner] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[initialDevWallet] = true;

        _mint(initialOwner, TOTAL_SUPPLY);
    }

    function _update(address sender, address recipient, uint256 amount) internal override {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient] || amount == 0) {
            super._update(sender, recipient, amount);
            return;
        }

        uint256 taxAmount = (amount * TAX_FEE) / 100;
        uint256 devFee = taxAmount / 2;
        uint256 burnFee = taxAmount - devFee;
        uint256 amountAfterTax = amount - taxAmount;

        super._update(sender, devWallet, devFee);
        super._burn(sender, burnFee);
        super._update(sender, recipient, amountAfterTax);
    }

    function setDevWallet(address newDevWallet) external onlyOwner {
        require(newDevWallet != address(0), "Ungueltige Adresse");
        devWallet = newDevWallet;
    }

    function setExcludedFromFee(address account, bool excluded) external onlyOwner {
        _isExcludedFromFee[account] = excluded;
    }
}
