contract AddressGroup {
    function addMember(address a) {
        if(!isMember(a)) {
            members[a] = true;
            memberTotal += 1;
        }
    }
    function removeMember(address a) {
        if(isMember(a)) {
            members[a] = false; 
            memberTotal -= 1;
            if(memberTotal==0) {
                suicide(a);
            }
        }
    }
    function isMember(address a) returns (bool) {
        return members[a];
    }
    modifier onlyMember { if(isMember(msg.sender)) { _ } }
    mapping (address => bool) members;
    uint public memberTotal;
}
