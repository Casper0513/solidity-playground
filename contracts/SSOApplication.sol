pragma solidity ^0.4.24;

import "./SingleSignOn.sol";
contract Application is SingleSignOn {
    
    uint16 sessionExpireTime = 2700; // log out if inactive for 45 minutes.
    
    mapping(address => mapping(uint256 => uint256)) lastTXTime;
    
    modifier checkSession(uint256 session, bytes32 ticket) {
        if(now - lastTXTime[msg.sender][session] >= sessionExpireTime) {
            logout(session, ticket);
            return;
        }
        
        lastTXTime[msg.sender][session] = now;
        _;
    }
    
    function login(uint256 session, bytes32 userFutureTicket) public {
        super.login(session, userFutureTicket);
        lastTXTime[msg.sender][session] = now;
    }
    
    function doSomething(
        uint256 session, 
        bytes32 ticket, 
        bytes32 userFutureTicket
        ) public checkSession(session, ticket) verifyUser(session, ticket) {
        
        futureTicketHash[msg.sender][session] = userFutureTicket;
    }
    
}