/*
    Website: https://butane.tech
    Contract Name: BUTANE Wrapped Token
    Discord: https://discord.gg/zk4t92b9MX
    Twitter: https://twitter.com/Butane_Network
    Telegram: https://t.me/butanechain

*/

// SPDX-License-Identifier: MIT
pragma solidity =0.8.16;

contract WTRESV4 {
  string private constant _NAME     = "Wrapped BBC";
  string private constant _SYMBOL   = "WBBC";
  uint8  private constant _DECIMALS = 18;
  uint256 private _totalSupply = address(this).balance;
  mapping (address => uint256) public  balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  event  Approval(address indexed src, address indexed guy, uint256 wad);
  event  Transfer(address indexed src, address indexed dst, uint256 wad);
  event  Deposit(address indexed dst, uint256 wad);
  event  Withdrawal(address indexed src, uint256 wad);

  receive() external payable {
    deposit();
  }

  function deposit() public payable {
    require(msg.sender != address(0), "Approve from the zero address");
    balanceOf[msg.sender] += msg.value;
    emit Deposit(msg.sender, msg.value);
  }

  function withdraw(uint256 wad) external {
    require(msg.sender != address(0), "Approve from the zero address");
    require(balanceOf[msg.sender] >= wad,"You can't withdraw more than your balance");
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
    emit Withdrawal(msg.sender, wad);
  }
  /**
   * @dev Returns the token decimals.
   */
  function decimals() external pure returns (uint8) {
    return _DECIMALS;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external pure returns (string memory) {
    return _SYMBOL;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external pure returns (string memory) {
    return _NAME;
  }
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  function approve(address guy, uint256 wad) external returns (bool) {
    require(guy != address(0), "Approve from the zero address");

    allowance[msg.sender][guy] = wad;
    emit Approval(msg.sender, guy, wad);
    return true;
  }

  function transfer(address dst, uint256 wad) external returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    require(balanceOf[src] >= wad, "The Source don't have enough balance");
    require(src != address(0), "Transfer from the zero address");
    require(dst != address(0), "Transfer to the zero address");
    require(wad > 0, "Transfer amount must be greater than zero");

    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      require(allowance[src][msg.sender] >= wad, "Not Enough Allowance for transfer.");
      allowance[src][msg.sender] -= wad;
    }

    balanceOf[src] -= wad;
    balanceOf[dst] += wad;

    emit Transfer(src, dst, wad);

    return true;
  }
}
