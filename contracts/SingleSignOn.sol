pragma solidity ^0.4.24;

contract SingleSignOn {
    
    event LoggedIn(address user, uint256 session);
    event LoggedOut(address user, uint256 session);
    
    mapping(address => mapping(uint256 => bool)) loggedInUser;
    mapping(address => mapping(uint256 => bytes32)) futureTicketHash;
    
    
    modifier verifyUser(uint256 session, bytes32 ticket) {
        require(loggedInUser[msg.sender][session]);
        require(futureTicketHash[msg.sender][session] == keccak256(abi.encodePacked(ticket)));
        _;
    }
    
    function login(uint256 session, bytes32 userFutureTicket) public {
        require(!loggedInUser[msg.sender][session]);
        
        emit LoggedIn(msg.sender, session);
        loggedInUser[msg.sender][session] = true;
        futureTicketHash[msg.sender][session] = userFutureTicket;
    }
    
    function logout(uint256 session, bytes32 ticket) public verifyUser(session, ticket) {
        
        emit LoggedOut(msg.sender, session);
        loggedInUser[msg.sender][session] = false;
    }
    
    function isLoggedIn(address user, uint256 session) public view returns (bool) {
        return loggedInUser[user][session];
    }
    function getFutureTicket(address user, uint256 session) public view returns (bytes32) {
        return futureTicketHash[user][session];
    }

}