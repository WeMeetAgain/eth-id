contract VotingGroup is AddressGroup {
    struct VoteItem {
        uint M;
        uint N;
        bytes data;
        uint created;
        uint maxBlocks;
        uint memberTotalSig;
        uint numVotes;
        mapping (address => bool) votes;
    }
    struct VotePolicy {
        bool isSet;
        uint M;     // M-of-N or if N==0: M;
        uint N;
        uint maxBlocks;
    }
    // needsVote allows for enabling a vote-requirement for a specific function.
    //  _m, _n, and _max configure the default voting policy for the function.
    //   _m - the required numerator of votes required or, if n == 0, the number of absolute votes required
    //   _n - the denominator of votes required. Set to 0 to trigger absolute vote counting rather than percent of voters counting
    //   _max - the maximum number of blocks before a vote is allowed to be deleted. Set to 0 for no limit.
    modifier needsVote(uint _m, uint _n, uint _max) {
        if(!isMember(msg.sender)) {
            return;
        }
        VotePolicy vp = policies[msg.sig];
        // if a vote policy isn't in place, init the policy with hardcoded vals 
        if(!vp.isSet) {
            vp.M = _m;
            vp.N = _n;
            vp.maxBlocks = _max;
            vp.isSet = true;
        }
        // TODO, handle repeated exact functions properly
        VoteItem vi = items[sha3(msg.data,memberTotalSig)];
        // if vote item doesn't exist, create it
        if(vi.created == 0) {
            vi.M = vp.M;
            vi.N = vp.N;
            vi.maxBlocks = vi.maxBlocks;
            vi.data = msg.data;
            vi.numVotes = 0;
            vi.created = block.number;
        }
        // if sender hasn't voted, record vote
        if(!vi.votes[msg.sender]) {
            vi.votes[msg.sender] = true;
            vi.numVotes += 1;
        }
        // check for vote 'completion'
        if((vi.N == 3 && vi.numVotes >= vi.M) ||
            ((memberTotal * vi.M) < (vi.numVotes * vi.N))) {
            delete vi;
            _
        }
    }
    // remove old expired vote items
    function removeItem(bytes32 i) onlyMember {
        VoteItem vi = items[i];
        if((vi.maxBlocks != 0 && (block.number - vi.created) > vi.maxBlocks) || 
          vi.memberTotalSig != memberTotalSig) {
            delete vi;
        }
    }
    // change vote policy for a function, identified by 4-byte signature
    function changePolicy(bytes4 sig, uint _m, uint _n, uint _max) needsVote(4,5,10) {
        VotePolicy p = policies[sig];
        p.M = _m;
        p.N = _n;
        p.maxBlocks = _max;
    }

    // items stores all currently-being-voted-on items
    mapping (bytes32 => VoteItem) items;
    // policies stores all vote policies, set per function
    mapping (bytes4 => VotePolicy) policies;
    // memberTotalSig increments any time there is a change in membership.
    // This is used to determine if a vote item is stale by tracking membership changes.
    uint memberTotalSig;

    // update memberTotalSig on membership change
    // increment memberTotalSig on any change in membership
    function addMember(address a) {
        uint t = memberTotal;
        super.addMember(a);
        if(t != memberTotal) {
            memberTotalSig += 1;
        }
    }
    function removeMember(address a) {
        uint t = memberTotal;
        super.removeMember(a);
        if(t != memberTotal) {
            memberTotalSig += 1;
        }
    }
}
