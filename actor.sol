// does not work yet, solidity does not allow bytes to be passed in
contract Actor {
    function act(address to, bytes data) {
        to.call(data);
    }
}
