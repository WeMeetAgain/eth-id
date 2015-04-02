contract Identity is Entity, AttributeList, VotingGroup {
    // entity
    // TODO: tailor entity method
    // attribute list access
    function setAttribute(bytes32 key, bytes32 value, bool linkable) needsVote(2,3,10) {
        super.setAttribute(key, value, linkable);
    }
    function removeAttribute(bytes32 key) needsVote(2,3,10) {
        super.removeAttribute(key);
    }
    // group membership
    function addMember(address a) needsVote(2,3,10) {
        super.addMember(a);
    }
    function removeMember(address a) needsVote(2,3,10) {
        super.removeMember(a);
    }
}
