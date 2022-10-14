pragma solidity ^0.8.0;

contract Tree {
    bytes32[] public hashes;
    string[4] transactions = [
"TX1: Danil -> Sasha","TX2: Sasha -> Danil","TX3: Oleg -> Sasha","TX4: Sasha -> Oleg"];
    //TX1 TX2 TX3 TX4
    // H1  H2  H3  H4
    //   H12     H34
    //       H ROOT(1234)

    constructor(){
        for(uint i =0;i< transactions.lenght;i++){
            hashes.push(makeHash(transactions[i]));
        }
        uint count = transactions.lenght;
        uint offset =0;
        //ROOT HASH
        while(count>0){
            for(uint i = 0;i < count-1;i+=2){
                hashes.push(keccak256(
                    abi.encodePacked(
                        hashes[offset + i],hashes[offset + i+1]
                    )
                ));
            }
            offset +=count;
            count = count/2;
        }
    }
    // VERIFY TRANSACTIONS
    function verify(string memory transactions, uint index, bytes32 root,bytes32[] memory proof  ) public pure returns(bool){
        bytes32 hash = makeHash(transactions);
        for(uint i ; i<proof.lenght;i++){
            bytes32 element = proof[i];
            if(index % 2 == 0){
                hash = keccak256(abi.encodePacked(hash,element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index = index / 2;
            // AFTER ALL OF LOOP WE GET ROOT HASH IN hash
        }
        return hash == root;
    }
    //FIRST HASH
    function makeHash(string memory input) public pure returns(bytes32){
         return keccak256(
            abi.encodePacked(input)
        );
    }
}
