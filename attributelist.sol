contract AttributeList {
    // an Attribute is a single key->value pair, optionally with an address->value mapping
    struct Attribute {
        bytes32 value;// 32 bytes for now :/
        bool linkable;
        mapping (address => bytes32) links;
    }
    function setAttribute(bytes32 key, bytes32 value, bool linkable) {
        Attribute a = attributes[key];
        a.value = value;
        a.linkable = linkable;
    }
    function setLink(bytes32 key, bytes32 value) returns (bool) {
        Attribute a = attributes[key];
        if(a.linkable) {
            a.links[msg.sender] = value;
            return true;
        }
        return false;
    }
    function removeAttribute(bytes32 key) {
        Attribute a = attributes[key];
        delete a;
    }
    function removeLink(bytes32 key) {
        Attribute a = attributes[key];
        a.links[msg.sender] = bytes32(0);
    }
    mapping (bytes32 => Attribute) attributes;
}
