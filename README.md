#eth-id
This is a simple implementation of an identity and component contracts. - WIP

PRs and suggestions welcome.

An identity is composed of three main components:
- Entity - perform arbitrary transactions. This allows the contract itself to have all degrees of freedom required to directly interact with other dapps. NOT CURRENTLY WORKING
- AttributeList - store key-> value pairs along with links to other addresses. This allows the identity itself to store a minimal amount of information along with any trusted linkages required to be public on the chain.
- VotingGroup - allow for the curtailing of all other actions by making functions votable and keeping track of 'member' addresses. This allows an identity to have decentralized control, emulating a multisig account, key revocation, etc.

##Entity

`Entity` has a single function:
- `act` - `address a`,`bytes data` - sends a transaction to `a` with payload `data`

##AttributeList

`AttributeList` has four functions:
- `addAttribute` - `bytes32 key`,`bytes32 val`, `bool linkable` - adds the attribute `key` with value `val`. If `linkable`, allows other addresses to link to this attribute
- `removeAttribute` - `bytes32 key` - removes the attribute `key`
- `addLink` - `bytes32 key`,`bytes32 val` - if the attribute exists and is linkable, adds the link with value `val` to attribute `key`, linked to `msg.sender`
- `removeLink` - `bytes32 key` - removes the link at attribute `key` linked to `msg.sender`. This works even if a previously linkable attribute is now unlinkable.

##VotingGroup

`VotingGroup` is an `AddressGroup`, it has a modifier and two functions:
- `needsVote` - `uint m`,`uint n`, `uint maxBlocks` - this modifier makes the function its applied to require a vote in order to be processed. The first vote that passes the vote threshold performs the function. `m` and `n` set the vote threshold, requiring `m`/`n` of the group members to vote on the function by all performing the function. If `n` is 0, `m` acts as an absolute number vote threshold to be reached before the function is called. `maxBlocks` sets a maximum block number of blocks before the vote can be deleted. If `maxBlocks` is 0, the feature is disabled for this vote, and the vote item will not be deletable by these means. If a voted item is not deleted, it can still be passed and run after the max number of blocks has passed. All vote items will become stale and unvotable if the number of members changes while the vote is in progress.
- `removeItem` - `bytes32 voteitem` - if the vote is stale or has passed the max number of blocks, remove the vote item identified by `voteitem`. `voteitem` is the sha3 of the `msg.data` of the vote item.
- `changePolicy` - `bytes4 sig`,`uint m`,`uint n`,`uint maxBlocks` - updates the vote policy for the function with the signature `sig`. If the vote does not have the modifier `needsVote`, this has no effect, otherwise, the updated policy will supercede the policy in the modifier.

##AddressGroup

`AddressGroup` has four functions and a modifier:
- `addMember` - `address a` - adds `a` to the group if a is not already in the group.
- `removeMember` - `address a` - removes `a` from the group if a is in the group.
- `isMember` - `address a` - returns `bool` - returns true if `a` is a member, false otherwise.
- `memberTotal` - returns the total number of addresses in the group.
- `onlyMember` - a modifier which lets a function only be run by a member of this group.

