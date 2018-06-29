function recordbid(string _message, string _author) public payable{
        acceptBid(msg.value);  //determine if bid is acceptable
        
        // Create Bid
        Bid memory currentBid = Bids[msg.sender];
        currentBid.message = _message;
        currentBid.author = _author;
        currentBid.paid = msg.value;
        authorAcct.push(msg.sender); //Save Bid author address in authorAcct list
        
        //Figure out the position to insert new bid
        uint256 position = bidList.length-1;
        
        /*
        for (uint i=bidList.length; i>0; i--){
            uint256 paid = bidList[i-1].paid;
            if (paid < msg.value)
                position = i-1;
                break;
        } */
        uint256 paid = bidList[position].paid;
        while(paid > msg.value){
            position--;
        }
        
        // Push all higher bids down by one
        for (uint j=bidList.length; j>position; j--){
            bidList[j] = bidList[j-1];
        }
        bidList[position] = currentBid; // save new bid in correct position
        
    }
    
    function displayAuthors() view public returns(address[]){
        return authorAcct;
    }
    
    function acceptBid(uint256 received) public payable returns(bool accept){
        uint minAmount = 20;
        require (received >= minAmount);
        return true;
    }
    /*
    function sortListInsert(uint256 paid){
        //Insert Sorting Algorithm
        //uint256 compare = 
    }*/
}
