pragma solidity ^0.4.20;
// Sentiment is an open messaging/expression Dapp -- 
// express yourself by publishing a message, your "author name"(can be anything)
// Each bid is put into a queue, higher bids up front
// Every 15s, the message at the top of the queue is broadcast, and removed from the queue
// Express yourself free of sensorship, prices set by the demand for the service

contract Sentiment {
    
    struct Bid {
        string message;
        string author;
        address addres;
        uint256 paid;
        uint256 tim;
    }
    
    address public superuser;
    uint256 public cBal;
    
    constructor() public{
        //Create initial Bid
        Bid storage initialBid = Bids[msg.sender];
        initialBid.message = "Hello World! Express yourself!";
        initialBid.author = "Stephane Gallet";
        initialBid.addres = msg.sender;
        initialBid.paid = 20;
        initialBid.tim = now;
        bidListStor.push(initialBid);
        superuser = msg.sender; //set superuser as the contract deployer
    }
    
    mapping(address => Bid) public Bids;
    Bid[] public bidListStor;
    uint256 public minAmount = 20;
    
    event broadcastNewBid(
        string message,
        string author,
        address addres,
        uint256 paid,
        uint256 tim
    );
    
    function recordbid(string _message, string _author) public payable{
        Bid[] storage bidList = bidListStor; // copy over bidList from storage to manipulate
        acceptBid(msg.value, _message);  //determine if bid is acceptable
        
        // Create Bid
        Bid storage currentBid = Bids[msg.sender];
        currentBid.message = _message;
        currentBid.author = _author;
        currentBid.addres = msg.sender;
        currentBid.paid = msg.value;
        currentBid.tim = now;
        //Figure out the position to insert new bid
        uint256 position = bidList.length;
        uint256 vpaid = bidList[position-1].paid; //max paid
        
        while (vpaid > msg.value && position > 0){
            position --;
            vpaid = bidList[position-1].paid;
        }
        
        if (position < bidList.length){
            // Push all higher bids down by one
            bidList.push(bidList[bidList.length-1]); //augment list size by 1, copy last item
            
            for (uint j=bidList.length-1; j>=position; j--){
                bidList[j] = bidList[j-1];
            } 
            bidList[position] = currentBid; // save new bid in correct position
        } else {
            bidList.push(currentBid); // save new bid in correct position
        }
        bidListStor = bidList;  //copy manipulated list onto public list
        emit broadcastNewBid(currentBid.message, currentBid.author,currentBid.addres,currentBid.paid,currentBid.tim);
    }
    
    function acceptBid(uint256 received, string _message) public payable returns(bool accept){
        require (received >= minAmount); //check amount paid is sufficient to get on list
        require (bytes(_message).length <= 10); //check max message size is not exceeded
        return true;
    }
    
    function resetMin(uint256 newMin) public{
        //Allow superuser to reset minimum bid amount
        require(msg.sender == superuser);
        minAmount = newMin;
    }
    
    function updateBal() public {
        require(msg.sender == superuser);
        cBal = address(this).balance;
    }
    
    function withDraw() public{
        require(msg.sender == superuser);
        msg.sender.transfer(address(this).balance);
        updateBal();
    }
    
    //TODO write fallback function, accept ether
}
