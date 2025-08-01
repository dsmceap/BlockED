//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IERC5484} from "./IERC5484.sol";
import {ERC721} from "https://cdn.jsdelivr.net/npm/@openzeppelin/contracts@4.9.0/token/ERC721/ERC721.sol";


abstract contract ERC5484 is ERC721, IERC5484 {
    //errors
    error ERC5484__AddressZeroCannotBeIssuer();
    error ERC5484__TokenHolldersCannotBeIssuers(address _issuer);

    error ERC5484__TokenAlreadyExists(uint256 _tokenId);
    error ERC5484__IssuerCannotIssueTokensToThem(address _issuer);

    error ERC5484__TokenDoesNotExists(uint256 _tokenId);
    error ERC5484__ThisTokenCannotBeBurned(uint256 _tokenId);
    error ERC5484__MsgSenderIsNotAllowedToBurn(address _entity);
    error ERC5484__TokenCanOnlyBeBurnedByOwner(address _entity);
    error ERC5484__TokenCanOnlyBeBurnedByIssuer(address _entity);

    error ERC5484__TransferingIsNotValidInSBT();
    error ERC5484__ApprovalIsNotValidInSBT();
    error ERC5484__NotIssuer();

    event IssuerSet(address indexed _issuer);

    mapping(address _entity => bool _isIssuer) private s_entityIsIssuer;
    mapping(uint256 _tokenId => BurnAuth _burnAuth) private s_burnAuthToToken; 

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    //transfer
    function _transfer(address from, address to, uint256 tokenId) internal override {
        if(!s_entityIsIssuer[msg.sender]) revert ERC5484__TransferingIsNotValidInSBT();
        super._transfer(from, to, tokenId);
    }

    function _safeTransfer(address /*from*/, address /*to*/, uint256 /*tokenId*/, bytes memory /*data*/) internal override {
        revert ERC5484__TransferingIsNotValidInSBT();
    }

    //approve
    function _approve(address /*to*/, uint256 /*tokenId*/) internal override  {
        revert ERC5484__ApprovalIsNotValidInSBT();
    }
    
    function _setApprovalForAll(address /*owner*/, address /*operator*/, bool /*approved*/) internal override {
        revert ERC5484__ApprovalIsNotValidInSBT();
    }



    function _setIssuer(address _entity, bool _isIssuer) internal virtual {
        _setIssuer(_entity, _isIssuer, '');
    }

    function _setIssuer(address _entity, bool _isIssuer, bytes memory) internal {
        if(_entity == address(0)) revert ERC5484__AddressZeroCannotBeIssuer();
        s_entityIsIssuer[_entity] = _isIssuer;
        emit IssuerSet(_entity);
    }

    function isIssuer(address _entity) public view returns(bool) {
        if(_entity == address(0)) revert ERC5484__AddressZeroCannotBeIssuer();
        return s_entityIsIssuer[_entity];
    }

    modifier onlyIssuer {
        if(!s_entityIsIssuer[msg.sender]) revert ERC5484__NotIssuer();
        _;
    }



    function _issue(address _to, uint256 _tokenId, BurnAuth _burnAuth) internal virtual {
        _issue(_to, _tokenId, _burnAuth, '');
    }
    
    
    function _issue(address _to, uint256 _tokenId, BurnAuth _burnAuth, bytes memory) internal {
        if(!s_entityIsIssuer[msg.sender]) revert ERC5484__NotIssuer(); 
        if(_exists(_tokenId)) revert ERC5484__TokenAlreadyExists(_tokenId);
        _safeMint(_to, _tokenId);
        s_burnAuthToToken[_tokenId] = _burnAuth;
        emit Issued(msg.sender, _to, _tokenId, _burnAuth);
    }

    function _authBurn(uint256 _tokenId) internal virtual {
        _burn(_tokenId);
    }

    function _burn(uint256 _tokenId) internal override  {

        if(!_exists(_tokenId)) revert ERC5484__TokenDoesNotExists(_tokenId);
        BurnAuth _burnAuth = s_burnAuthToToken[_tokenId];
        
        if(_burnAuth == BurnAuth.Neither) revert ERC5484__ThisTokenCannotBeBurned(_tokenId);

        if(msg.sender != ownerOf(_tokenId) && !isIssuer(msg.sender)) revert ERC5484__MsgSenderIsNotAllowedToBurn(msg.sender);
        
        if(_burnAuth == BurnAuth.OwnerOnly) {
            if (msg.sender != ownerOf(_tokenId)) revert ERC5484__TokenCanOnlyBeBurnedByOwner(msg.sender);
        }

        if(_burnAuth == BurnAuth.IssuerOnly) {
            if(!isIssuer(msg.sender)) revert ERC5484__TokenCanOnlyBeBurnedByIssuer(msg.sender);
        }

        s_burnAuthToToken[_tokenId] = BurnAuth.IssuerOnly;
        super._burn(_tokenId);

    }

    function burnAuth(uint256 _tokenId) external view returns (BurnAuth) {
        return s_burnAuthToToken[_tokenId];
    }

}