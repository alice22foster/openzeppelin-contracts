pragma solidity ^0.6.0;

import "../utils/EnumerableSet.sol";

contract EnumerableSetMock{
    using EnumerableSet for EnumerableSet.AddressSet;

    event TransactionResult(bool result);

    EnumerableSet.AddressSet private set;

    function contains(address key) public view returns (bool) {
        return set.contains(key);
    }

    function add(address key) public {
        bool result = set.add(key);
        emit TransactionResult(result);
    }

    function remove(address key) public {
        bool result = set.remove(key);
        emit TransactionResult(result);
    }

    function enumerate() public view returns (address[] memory) {
        return set.enumerate();
    }

    function length() public view returns (uint256) {
        return set.length();
    }

    function get(uint256 index) public view returns (address) {
        return set.get(index);
    }
}
