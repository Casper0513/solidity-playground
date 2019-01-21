pragma solidity ^0.4.24;

import "./SingleSignOn.sol";

contract Application is SingleSignOn {
    
    uint16 inactiveLogoutTime = 2700; // log out if inactive for 45 minutes.
    
    mapping(address => mapping(uint256 => uint256)) lastTXTime;
    
    modifier verifyLastTXTime(uint256 session, bytes32 ticket) {
        if(now - lastTXTime[msg.sender][session] >= inactiveLogoutTime) {
            logout(session, ticket);
            return;
        }
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
        ) public verifyLastTXTime(session, ticket) verifyUser(session, ticket) {
        
        futureTicketHash[msg.sender][session] = userFutureTicket;
    }
    
}