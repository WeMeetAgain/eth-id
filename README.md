#eth-id
This is a simple implementation of an identity and component contracts. - WIP

An identity is composed of three main components:
- Actor - perform arbitrary transactions. This allows the contract itself to have all degrees of freedom required to directly interact with other dapps. NOT CURRENTLY WORKING
- AttributeList - store key-> value pairs along with links to other addresses. This allows the identity itself to store a minimal amount of information along with any trusted linkages required to be public on the chain.
- VotingGroup - allow for the curtailing of all other actions by making functions votable. This allows an identity to have decentralized control, emulating a multisig account, key revocation, etc.
