// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; // 0.8.12
// pragma solidity ^0.8.0;
// CTRL+ S = compile

contract SimpleStorage {
    // boolean, uint, int, address, bytes
    // This gets initialized to zero!
    // public ketword = auomatically makes getter function
    // visibility default internal 
    // => varaibles can be only called by this contract, children contract 
    uint256 favoriteNumber; 

    //uint256[] public favoriteNumbersList;
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;
    
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        retrieve();
    }

    // view, pure funciton doesn't spend gas
    // if gas calling function calls a view or pure function -> only then will it cost gas
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function add() public pure returns(uint256){
        return(1+1);
    }

    // calldata, memory, storage
    // calldata -> temporary + x modifiable
    // memory -> temporary + modifiable
    // storage -> permanent default outside funciton
    // We only need to specify data location for array, struct, or mappings
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        //people.push(People(_favoriteNumber, _name));
        People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}
