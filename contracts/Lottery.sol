pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        //msg is a global variable in any solidity contract
        // it's how you access info about the TX calling the contract
        //.sender is the person who created the contract
        manager = msg.sender;
    }

    // function modifiers are kinda like traits in rust
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    //payable if someone's going to attach ETH to what they're sending
    function enter() public payable {
        //require means the person calling the function MUST fulfill requirements
        //this requires they attach more than 10000 wei
        require(msg.value > 100000 wei);
        players.push(msg.sender);
    }

    //no randomness function within solidity, can sorta generate your own but don't in prod
    function random() private view returns (uint) {
        //uint of a hash off the block difficulty, now, and players
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }

    function pickWinner() public restricted {
        //contract caller needs to be manager address, same person who created the contract
        //require(msg.sender == manager);

        uint index = random() % players.length;
        //payout winner by sending them all the eth in this contract
        players[index].transfer(address(this).balance);
        //reset players, balance is 0 now
        players = new address[](0);
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}