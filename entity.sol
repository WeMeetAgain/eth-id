// does not work yet, solidity does not allow bytes to be passed in
contract Entity {
    function act(address to, bytes data) {
        to.call(data);
    }
}
