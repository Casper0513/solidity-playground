pragma solidity ^0.4.24;

interface ERC223Receiver {
    function ERC223ReceiverFallBack(address _from, uint _value, bytes _data) external;
}

interface ERC223 {
  function balanceOf(address who) external view returns (uint);
  function transfer(address to, uint value) external returns (bool ok);
  function transfer(address to, uint value, bytes data) external returns (bool ok);
  function transfer(address to, uint value, bytes data, string custom_fallback) external returns (bool ok);
  
  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

contract ERC223Bank is ERC223Receiver {
    
    mapping(address => mapping(address => uint)) locker;
    
    function balance(address tokenAddress) public view returns (uint) {
        return (locker[msg.sender][tokenAddress]);
    }
    
    function deposit(address user, uint tokenCount) private {
        require(ERC223(msg.sender).balanceOf(user) >= tokenCount);
        
        locker[user][msg.sender] = tokenCount;
    }
    
    function withdraw(address tokenAddress, uint value) public {
        require(locker[msg.sender][tokenAddress] >= value);
        
        ERC223 erc223Token = ERC223(tokenAddress);
        erc223Token.transfer(msg.sender, value);
        locker[msg.sender][tokenAddress] -= value;
    }
    
    function ERC223ReceiverFallBack(address _from, uint _value, bytes _data) external {
        deposit(_from, _value);
    }
}