pragma solidity ^0.4.18;

contract SimpleStorage {
    address public _creator;
    address public _owner;

    //Hash of data to IPFS address
    string storedHash;

    struct Permission {
      bool exists;
      bool read;
      bool write;
    }

    mapping(address => Permission) _permissions;

    modifier onlyCreator {
      require(msg.sender == _creator);
      _;
    }

    modifier onlyOwner {
      require(msg.sender == _owner);
      _;
    }

    modifier onlyReadPermission {
      require (_permissions[msg.sender].read == true);
      _;
    }

    function SimpleStorage(){
      _creator = msg.sender;
      _owner = msg.sender;

      _permissions[_owner] = Permission({
        exists: true,
        read: true,
        write: true
        });
    }

    function sethash (string x) public {
        storedHash = x;
    }

    function grantOwnership (address account) public onlyOwner {
      _owner = account;
    }

    function grantRead (address account) public onlyOwner {
      _permissions[account] = Permission({
        exists: true,
        read: true,
        write: false
        });
    }

    function revokeRead (address account) public onlyOwner {
      _permissions[account] = Permission({
        exists: true,
        read: false,
        write: false
        });
    }

    /*~~~~~~~~~~~~~~~~~Getters~~~~~~~~~~~~~~~~~*/

    function hasRead (address account) public returns (bool) {
      if(_permissions[account].read) {
        return true;
      }
      return false;
    }

    function isOwner () public returns(address x){
      return _owner;
    }

    function getHash() public onlyReadPermission returns (string x) {
      return storedHash;
    }
}
