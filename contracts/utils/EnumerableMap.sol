pragma solidity ^0.6.0;

library EnumerableMap {
    struct UintToAddressEntry {
        uint256 key;
        address value;
    }

    struct UintToAddressMap {
        // Position of the value in the `entries` array, plus 1 because index 0
        // means a value is not in the map.
        mapping (uint256 => uint256) index;
        UintToAddressEntry[] entries;
    }

    /**
     * @dev Add a key-value pair to a map. O(1).
     * If the key was already in the map, its value is updated and returns
     * false.
     */
    function add(UintToAddressMap storage map, uint256 key, address value)
        internal
        returns (bool)
    {
        if (!contains(map, key)) {
            map.entries.push(UintToAddressEntry({ key: key, value: value }));
            // The entry is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            map.index[key] = map.entries.length;
            return true;
        } else {
            map.entries[map.index[key] - 1].value = value;
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     * Returns false if the value was not present in the set.
     */
    function remove(UintToAddressMap storage map, uint256 key)
        internal
        returns (bool)
    {
        if (contains(map, key)){
            uint256 toDeleteIndex = map.index[key] - 1;
            uint256 lastIndex = map.entries.length - 1;

            // If the element we're deleting is the last one, we can just remove it without doing a swap
            if (lastIndex != toDeleteIndex) {
                UintToAddressEntry storage lastEntry = map.entries[lastIndex];

                // Move the last entry to the index where the deleted entry is
                map.entries[toDeleteIndex] = lastEntry;
                // Update the index for the moved entry
                map.index[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based
            }

            // Delete index for the deleted entry
            delete map.index[key];

            // Delete the slot where the moved entry was stored
            map.entries.pop();

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(UintToAddressMap storage map, uint256 key)
        internal
        view
        returns (bool)
    {
        return map.index[key] != 0;
    }

    /**
     * @dev Returns the number of elements on the set. O(1).
     */
    function length(UintToAddressMap storage map)
        internal
        view
        returns (uint256)
    {
        return map.entries.length;
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
    function get(UintToAddressMap storage map, uint256 index)
        internal
        view
        returns (uint256, address)
    {
        UintToAddressEntry storage entry = map.entries[index];
        return (entry.key, entry.value);
    }

    function value(UintToAddressMap storage map, uint256 key)
        internal
        view
        returns (address)
    {
        return map.entries[map.index[key] - 1].value;
    }
}
