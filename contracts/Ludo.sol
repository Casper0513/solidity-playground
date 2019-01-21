pragma solidity ^0.4.24;

contract Ludo {
    
    enum Color {
        NULL,
        RED,
        GREEN,
        YELLOW,
        BLUE
    }
    
    event Random(address sender, uint session, uint8 diceValue);
    
    struct Cell {
        uint8 position;
        Color color;
        bool isStar;
        uint8 nextPosition;
        uint8 homeEntryPos;
    }
    
    struct Goti {
        Color color;
        uint8 id;
        uint8 position;
    }
    
    struct User {
        address userAddress;
        uint8 color;
    }
    
    mapping(uint8 => Cell) board;
    //first uint8 = color
    //second uint8 = id (1,2,3,4)
    mapping(uint8 => mapping(uint8 => Goti)) gotis;
    //uint8 = color
    //User = user structure
    mapping(uint8 => User) players2;
    mapping(address => User) players;
    uint8 playersCount;
    address gameOperator;
    uint8 turn;
    uint8 public diceValue;
    bool gameStarted;
    
    modifier gameRunning {
        require(gameStarted);
        _;
    }
    
    modifier waitingPlayers {
        require(!gameStarted);
        require(playersCount < 4);
        require(msg.sender != address(0));
        require(players[msg.sender].userAddress == address(0));
        _;
    }
    
    modifier onlyGameOperator {
        require(msg.sender == gameOperator);
        _;
    }
    
    function random() public returns(uint){
        bytes32 hash = keccak256(abi.encodePacked(now, msg.sender, diceValue));
        diceValue = uint8(uint(hash))%(6) + 1;
        emit Random(msg.sender, 0, diceValue);
    }
    
    function join(uint8 color) public waitingPlayers {
        
        players[msg.sender].userAddress = msg.sender;
        players[msg.sender].color = color;
        if(++playersCount == 1){
            gameOperator = msg.sender;
        }
    }
    
    function start() public onlyGameOperator {
        gameStarted = true;
    }
    
    function move(uint8 gotiId) public gameRunning {
        require(gotiId <= 4);
        require(msg.sender != address(0));
        require(players[msg.sender].userAddress == msg.sender);
        
        uint8 color = players[msg.sender].color;
        Goti storage goti = gotis[color][gotiId];
        uint8 currPos;
        bool win = true;
        
        for(uint8 i=1; i<=diceValue; i++) {
            currPos = goti.position;
            if(board[currPos].homeEntryPos > 0 && goti.color == board[board[currPos].homeEntryPos].color){
                goti.position = board[currPos].homeEntryPos;
            }else{
               goti.position = board[currPos].nextPosition; 
            }
        }
        
        require(goti.position <= 101);
        
        if(goti.position == 101) {
            if(gotis[color][1].position != 101) win = false;
            if(gotis[color][2].position != 101) win = false;
            if(gotis[color][3].position != 101) win = false;
            if(gotis[color][4].position != 101) win = false;
        }
        
        if(win){
            gameStarted = false;
        }
       
    }
    
    constructor() public {
        
        // ludo board
        
        //red to green
        board[0] = Cell(0, Color.NULL,  true, 1, 0);
        board[1] = Cell(1, Color.NULL, false, 2, 0);
        board[2] = Cell(2, Color.NULL, false, 3, 0);
        board[3] = Cell(3, Color.NULL, false, 4, 0);
        board[4] = Cell(4, Color.NULL, false, 5, 0);
        board[5] = Cell(5, Color.NULL, false, 6, 0);
        board[6] = Cell(6, Color.NULL, false, 7, 0);
        board[7] = Cell(7, Color.NULL, false, 8, 0);
        board[8] = Cell(8, Color.NULL, false, 9, 0);
        board[9] = Cell(9, Color.NULL, false, 10, 0);
        board[10] = Cell(10, Color.NULL, false, 11, 0);
        board[11] = Cell(11, Color.NULL, false, 12, 57); // green home starts
        board[12] = Cell(12, Color.NULL, false, 13, 0);
        
        
        //green to yellow
        board[13] = Cell(13, Color.NULL,  true, 14, 0);
        board[14] = Cell(14, Color.NULL, false, 15, 0);
        board[15] = Cell(15, Color.NULL, false, 16, 0);
        board[16] = Cell(16, Color.NULL, false, 17, 0);
        board[17] = Cell(17, Color.NULL, false, 18, 0);
        board[18] = Cell(18, Color.NULL, false, 19, 0);
        board[19] = Cell(19, Color.NULL, false, 20, 0);
        board[20] = Cell(20, Color.NULL, false, 21, 0);
        board[21] = Cell(21, Color.NULL, false, 22, 0);
        board[22] = Cell(22, Color.NULL, false, 23, 0);
        board[23] = Cell(23, Color.NULL, false, 24, 0);
        board[24] = Cell(24, Color.NULL, false, 25, 62); // yellow home starts
        board[25] = Cell(25, Color.NULL, false, 26, 0);
        
        //yellow to blue
        board[26] = Cell(26, Color.NULL,  true, 27, 0);
		board[27] = Cell(27, Color.NULL, false, 28, 0);
        board[28] = Cell(28, Color.NULL, false, 29, 0);
        board[29] = Cell(29, Color.NULL, false, 30, 0);
        board[30] = Cell(30, Color.NULL, false, 31, 0);
        board[31] = Cell(31, Color.NULL, false, 32, 0);
        board[32] = Cell(32, Color.NULL, false, 33, 0);
        board[33] = Cell(33, Color.NULL, false, 34, 0);
        board[34] = Cell(34, Color.NULL, false, 35, 0);
        board[35] = Cell(35, Color.NULL, false, 36, 0);
        board[36] = Cell(36, Color.NULL, false, 37, 0);
        board[37] = Cell(37, Color.NULL, false, 38, 67); // blue home starts
        board[38] = Cell(38, Color.NULL, false, 39, 0); 
        
        
        //blue to red
        board[39] = Cell(39, Color.NULL,  true, 40, 0);
        board[40] = Cell(40, Color.NULL, false, 41, 0);
        board[41] = Cell(41, Color.NULL, false, 42, 0);
        board[42] = Cell(42, Color.NULL, false, 43, 0);
        board[43] = Cell(43, Color.NULL, false, 44, 0);
        board[44] = Cell(44, Color.NULL, false, 45, 0);
        board[45] = Cell(45, Color.NULL, false, 46, 0);
        board[46] = Cell(46, Color.NULL, false, 47, 0);
        board[47] = Cell(47, Color.NULL, false, 48, 0);
        board[48] = Cell(48, Color.NULL, false, 49, 0);
        board[49] = Cell(49, Color.NULL, false, 50, 0);
        board[50] = Cell(50, Color.NULL, false, 51, 52); // red home starts
        board[51] = Cell(51, Color.NULL, false, 0, 0);
        
        //red home
        board[52] = Cell(52, Color.RED, false, 4, 53);
        board[53] = Cell(53, Color.RED, false, 4, 54);
        board[54] = Cell(54, Color.RED, false, 4, 55);
        board[55] = Cell(55, Color.RED, false, 4, 56);
        board[56] = Cell(56, Color.RED, false, 4, 101);
        
        //green home
        board[57] = Cell(57, Color.RED, false, 4, 58);
        board[58] = Cell(58, Color.RED, false, 4, 59);
        board[59] = Cell(59, Color.RED, false, 4, 60);
        board[60] = Cell(60, Color.RED, false, 4, 61);
        board[61] = Cell(61, Color.RED, false, 4, 101);
        
        //yellow home
        board[62] = Cell(62, Color.RED, false, 4, 63);
        board[63] = Cell(63, Color.RED, false, 4, 64);
        board[64] = Cell(64, Color.RED, false, 4, 65);
        board[65] = Cell(65, Color.RED, false, 4, 66);
        board[66] = Cell(66, Color.RED, false, 4, 101);
        
        //blue home
        board[67] = Cell(67, Color.RED, false, 4, 68);
        board[68] = Cell(68, Color.RED, false, 4, 69);
        board[69] = Cell(69, Color.RED, false, 4, 70);
        board[70] = Cell(70, Color.RED, false, 4, 71);
        board[71] = Cell(71, Color.RED, false, 4, 101);
        
        
        // ludo gotis
        // red goti
        gotis[1][1] = Goti(Color.RED, 1, 100);
        gotis[1][2] = Goti(Color.RED, 2, 100);
        gotis[1][3] = Goti(Color.RED, 3, 100);
        gotis[1][4] = Goti(Color.RED, 4, 100);
        
        //green goti
        gotis[2][1] = Goti(Color.GREEN, 1, 100);
        gotis[2][2] = Goti(Color.GREEN, 2, 100);
        gotis[2][3] = Goti(Color.GREEN, 3, 100);
        gotis[2][4] = Goti(Color.GREEN, 4, 100);
        
        //yellow goti
        gotis[3][1] = Goti(Color.YELLOW, 1, 100);
        gotis[3][2] = Goti(Color.YELLOW, 2, 100);
        gotis[3][3] = Goti(Color.YELLOW, 3, 100);
        gotis[3][4] = Goti(Color.YELLOW, 4, 100);
        
        //blue goti
        gotis[4][1] = Goti(Color.BLUE, 1, 100);
        gotis[4][2] = Goti(Color.BLUE, 2, 100);
        gotis[4][3] = Goti(Color.BLUE, 3, 100);
        gotis[4][4] = Goti(Color.BLUE, 4, 100);
    }
    
}