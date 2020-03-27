pragma solidity ^0.6.0;

library EnumerableMap {
    struct MapEntry {
        bytes32 key;
        bytes32 value;
    }

    struct Map {
        // Storage of map keys and values
        MapEntry[] entries;

        // Position of the entry defined by a key in the `entries` array, plus 1
        // because index 0 means a key is not in the map.
        mapping (bytes32 => uint256) indexes;
    }

    /**
     * @dev Add a key-value pair to a map. O(1).
     *
     * If the key was already in the map, its value is updated and returns
     * false.
     */
    function add(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
        if (!contains(map, key)) {
            map.entries.push(MapEntry({ key: key, value: value }));
            // The entry is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            map.indexes[key] = map.entries.length;
            return true;
        } else {
            map.entries[map.indexes[key] - 1].value = value;
            return false;
        }
    }

    /**
     * @dev Removes a key-value pair from a map. O(1).
     *
     * Returns false if the key was not present in the map.
     */
    function remove(Map storage map, bytes32 key) private returns (bool) {
        if (contains(map, key)){
            uint256 toDeleteIndex = map.indexes[key] - 1;
            uint256 lastIndex = map.entries.length - 1;

            // If the element we're deleting is the last one, we can just remove it without doing a swap
            if (lastIndex != toDeleteIndex) {
                MapEntry storage lastEntry = map.entries[lastIndex];

                // Move the last entry to the index where the entry to delete is
                map.entries[toDeleteIndex] = lastEntry;
                // Update the index for the moved entry
                map.indexes[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based
            }

            // Delete the slot where the moved entry was stored
            map.entries.pop();

            // Delete the index for the deleted slot
            delete map.indexes[key];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(Map storage map, bytes32 key) private view returns (bool) {
        return map.indexes[key] != 0;
    }

    /**
     * @dev Returns the number of key-value pairs in the map. O(1).
     */
    function length(Map storage map) private view returns (uint256) {
        return map.entries.length;
    }

   /**
    * @dev Returns the key-value pair stored at position `index` in the map. O(1).
    *
    * Note that there are no guarantees on the ordering of entries inside the
    * array, and it may change when more entries are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function get(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
        MapEntry storage entry = map.entries[index];
        return (entry.key, entry.value);
    }

    function value(Map storage map, bytes32 key) private view returns (bytes32) {
        return map.entries[map.indexes[key] - 1].value;
    }

    struct UintToAddressMap {
        Map _wrappedMap;
    }

    /**
     * @dev Add a key-value pair to a map. O(1).
     * If the key was already in the map, its value is updated and returns
     * false.
     */
    function add(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
        return add(map._wrappedMap, bytes32(key), bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     * Returns false if the value was not present in the set.
     */
    function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return remove(map._wrappedMap, bytes32(key));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return contains(map._wrappedMap, bytes32(key));
    }

    /**
     * @dev Returns the number of elements on the set. O(1).
     */
    function length(UintToAddressMap storage map) internal view returns (uint256) {
        return length(map._wrappedMap);
    }

   /**
    * @dev Returns the element stored at position `index` in the set. O(1).
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function get(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = get(map._wrappedMap, index);
        return (uint256(key), address(uint256(value)));
    }

    function value(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint256(value(map._wrappedMap, bytes32(key))));
    }
}
