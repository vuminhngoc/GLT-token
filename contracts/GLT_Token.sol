// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;
import "./ERC20/ERC20.sol";
import "./ERC20/IERC20.sol";
import "./ERC20/SafeERC20.sol";
import "./access/Ownable.sol";

contract GLT is ERC20, Ownable {
    using SafeERC20 for IERC20;
    
    

    constructor() ERC20("Gameloft Token", "GLT") {
        _mint(
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            42000000000000000000000
        ); //21% token Private sale ~42M tokens
        _mint(
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
            75714000000000000000000
        ); //3.7857% public sale ~7.5M tokens
        _mint(
            0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c,
            30000000000000000000000
        ); //15% Deposit 
        _mint(
            0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c,
            30000000000000000000000
        ); //15% marketing
        _mint(
            0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB,
            6000000000000000000000
        ); //3% Partner
        _mint(
            0x617F2E2fD72FD9D5503197092aC168c91465E7f2,
            24000000000000000000000
        ); //12% team 
        _mint(
            0x17F6AD8Ef982297579C203069C1DbfFE4348c372,
            30000000000000000000000
        ); //15% Development
        _mint(
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
            28428600000000000000000
        ); //14.2143% Resever
        _mint(
            0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678,
            2000000000000000000000
        ); //1% Airdrop
    }

    /* ========== EMERGENCY ========== */
    /*
    Users make mistake by transfering usdt/busd ... to contract address. 
    This function allows contract owner to withdraw those tokens and send back to users.
    */
    function rescueStuckErc20(address _token) external onlyOwner {
        uint256 _amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(owner(), _amount);
    }
}