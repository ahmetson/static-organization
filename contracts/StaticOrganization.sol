// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.9;

// we can add a new function to return any erc20 or nft
// transferred into this smartcontract
contract StaticOrganization {
    mapping(string => bool) public organizations;
    // fileName => CID
    mapping(string => string) public smartcontracts;
    // org => fileName[]
    mapping(string => string[]) public organizationSmartcontracts;
    // fileName => CID
    mapping(string => string) public configurations;
    // org => fileName[]
    mapping(string => string[]) public organizationConfigurations;

    event InsertOrganization(string indexed org);
    event InsertSmartcontract(string indexed org, string indexed fileName, string indexed cid);
    event DeleteSmartcontract(string indexed org, string indexed fileName);
    event UpdateSmartcontract(string indexed fileName, string indexed cid);
    event InsertConfiguration(string indexed org, string indexed fileName, string indexed cid);
    event DeleteConfiguration(string indexed org, string indexed fileName);
    event UpdateConfiguration(string indexed fileName, string indexed cid);

    constructor() {}

    function insertOrganization(string calldata org) external {
        require(bytes(org).length > 0, "org empty");
        require(!organizations[org], "organization inserted");

        organizations[org] = true;

        emit InsertOrganization(org);
    }

    function insertSmartcontract(string calldata org, string calldata fileName, string calldata cid) external {
        require(bytes(org).length > 0, "org empty");
        require(bytes(fileName).length > 0, "fileName empty");
        require(bytes(cid).length > 0, "cid empty");
        require(organizations[org], "org not inserted");
        require(bytes(smartcontracts[fileName]).length == 0, "smartcontract inserted");

        smartcontracts[fileName] = cid;
        organizationSmartcontracts[org].push(fileName);

        emit InsertSmartcontract(org, fileName, cid);
    }

    function deleteSmartcontract(string calldata org, string calldata fileName) external {
        require(bytes(org).length > 0, "org empty");
        require(bytes(fileName).length > 0, "fileName empty");
        require(organizations[org], "org not inserted");
        require(bytes(smartcontracts[fileName]).length > 0, "smartcontract not inserted");

        delete smartcontracts[fileName];
        deleteElement(organizationSmartcontracts[org], fileName);

        emit DeleteSmartcontract(org, fileName);
    }

    function updateSmartcontract(string calldata fileName, string calldata cid) external {
        require(bytes(fileName).length > 0, "fileName empty");
        require(bytes(smartcontracts[fileName]).length > 0, "smartcontract not inserted");

        smartcontracts[fileName] = cid;

        emit UpdateSmartcontract(fileName, cid);
    }

    function insertConfiguration(string calldata org, string calldata fileName, string calldata cid) external {
        require(bytes(org).length > 0, "org empty");
        require(bytes(fileName).length > 0, "fileName empty");
        require(bytes(cid).length > 0, "cid empty");
        require(organizations[org], "org not inserted");
        require(bytes(configurations[fileName]).length == 0, "configuration inserted");

        configurations[fileName] = cid;
        organizationConfigurations[org].push(fileName);

        emit InsertConfiguration(org, fileName, cid);
    }

    function deleteConfiguration(string calldata org, string calldata fileName) external {
        require(bytes(org).length > 0, "org empty");
        require(bytes(fileName).length > 0, "fileName empty");
        require(organizations[org], "org not inserted");
        require(bytes(configurations[fileName]).length > 0, "configuration not inserted");

        delete configurations[fileName];
        deleteElement(organizationConfigurations[org], fileName);

        emit DeleteConfiguration(org, fileName);
    }

    function updateConfiguration(string calldata fileName, string calldata cid) external {
        require(bytes(fileName).length > 0, "fileName empty");
        require(bytes(configurations[fileName]).length > 0, "configuration not inserted");

        configurations[fileName] = cid;

        emit UpdateConfiguration(fileName, cid);
    }

    function deleteElement(string[] storage fileNames, string memory name) internal {
        // first find the index
        uint index = 0;
        bool found = false;
        for (uint i = 0; i < fileNames.length; i++) {
            if (compareStrings(fileNames[i], name)) {
                index = i;
                found = true;
                break;
            }
        }

        require(found, "name not in fileNames");

        for (uint i = index; i<fileNames.length-1; i++){
            fileNames[i] = fileNames[i+1];
        }
        fileNames.pop();
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
