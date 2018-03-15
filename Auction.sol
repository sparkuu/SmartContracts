contract decentralisedAuction{
	struct auction {
		uint deadline;
		uint highestBid;
		address highestBidder;
		address recipient;
	}
  
	mapping(uint => auction) Auctions;
	uint numAuctions;

	function startAuction(uint timeLimit) returns (uint auctionID){
		auctionID = numAuctions++;
		Auctions[auctionID].deadline = block.number + timeLimit;
		Auctions[auctionID].recipient = msg.sender;
	}
  
	function bid(uint id) returns (address highestBidder){
		auction a = Auctions[id];
		if (a.highestBid + 1*10^18 > msg.value || a.deadline > block.number) {
			msg.sender.send(msg.value);
			return a.highestBidder;
		}
		a.highestBidder.send(a.highestBid);
		a.highestBidder = msg.sender;
		a.highestBid = msg.value;
		return msg.sender;
	}
  
	function endAuction(uint id) returns (address highestBidder){
		auction a = Auctions[id];
		if (block.number >= a.deadline) {
			a.recipient.send(a.highestBid);
			a.highestBid = 0;
			a.highestBidder =0;
			a.deadline = 0;
			a.recipient = 0;
		}
	}
}
