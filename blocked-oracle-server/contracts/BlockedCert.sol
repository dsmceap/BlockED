//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Ownable} from "https://cdn.jsdelivr.net/npm/@openzeppelin/contracts@4.9.0/access/Ownable.sol";
import {ERC5484} from "./ERC5484.sol";

contract BlockedCert is Ownable, ERC5484 {

    event CertIssued(uint indexed certId, bytes indexed hashData, address receiver);
    event CertVerified(uint indexed certId, bool indexed active);
    event CertUpdated(uint indexed certId, bytes indexed hashData, address receiver);
    event CertBurned(uint indexed certId);

    error BlockedCert__EmptyCertificate();
    error BlockedCert__InvalidCertificate();
    error BlockedCert__InvalidDuration(uint256 durationInYears);
    error BlockedCert__PastTime(uint256 timestamp);
    error BlockedCert__ProtocolEnded();

    struct Certificate { // hashData, createdAt, activeUntil, lastVerification, numOfVerifications
        bytes hashData;
        uint64 createdAt;
        uint64 activeUntil;
        uint64 lastVerification;
        uint32 numberOfVerifications;
    }

    uint256 public constant YEAR = 365 days;
    uint256 public constant MINIMUM_DURATION = 1 * YEAR;
    uint256 public constant PROTOCOL_LIFETIME = type(uint64).max;

    mapping(bytes hashData => bool exists) public hashDataExists;
    mapping(bytes hashData => uint256 certId) public hashDataToCertId;
    mapping(uint256 certId => Certificate) public certificates;
    uint256 nextCertId;

    constructor() ERC5484("Blocked", "BC"){
        nextCertId = 0;
    }

    function issueCertificate(string calldata certHash, uint256 durationInYears, address receiver) external onlyIssuer returns(bool) {
        address issuer = msg.sender;
        bytes memory hashData = abi.encodePacked(certHash);
        if(keccak256(hashData) == keccak256(abi.encodePacked(""))) revert BlockedCert__EmptyCertificate();
        uint256 currentTimestamp = block.timestamp;
        uint256 activeUntil = _handleCertificateDuration(durationInYears, currentTimestamp);
        if (hashDataExists[hashData]) return false;
        if(receiver == address(0)) receiver = issuer;
        nextCertId++;
        uint256 currentCertId = nextCertId;
        hashDataExists[hashData] = true;
        hashDataToCertId[hashData] = currentCertId;
        certificates[currentCertId] = Certificate(hashData, uint64(currentTimestamp), uint64(activeUntil), 0, 0);
        _issue(receiver, currentCertId, BurnAuth.IssuerOnly);
        emit CertIssued(currentCertId, hashData, issuer);
        return true; 
    }

    function verifyCertificateByHash(string calldata certHash) external returns(bool) {
        bytes memory hashData = abi.encodePacked(certHash);
        if (!hashDataExists[hashData]) return false;
        uint256 certId = hashDataToCertId[hashData];
        return _verifyCertificate(certId);
    } 

    function verifyCertificateById(uint256 certId) external returns(bool) {
        if (certId > nextCertId || !_exists(certId)) revert BlockedCert__InvalidCertificate();
        return _verifyCertificate(certId);
    }

    function _verifyCertificate(uint certId) internal returns(bool) {
        Certificate storage certificate = certificates[certId];
        uint256 currentTimestamp = block.timestamp;
        certificate.numberOfVerifications++;
        certificate.lastVerification = uint32(currentTimestamp);
        bool active = currentTimestamp <= certificate.activeUntil;
        emit CertVerified(certId, active);
        return active;
    }

    function updateCertificateById(uint256 certId, string calldata newCertHash, uint256 newDurationInYears, address receiver) external onlyIssuer {
        if (certId > nextCertId || !_exists(certId)) revert BlockedCert__InvalidCertificate();
        _updateCertificate(certId, newCertHash, newDurationInYears, receiver);
    }

    function updateCertificateByHash(string calldata prevCertHash, string calldata newCertHash, uint256 newDurationInYears, address receiver) external onlyIssuer {
        bytes memory hashData = abi.encodePacked(prevCertHash);
        if (!hashDataExists[hashData]) revert BlockedCert__InvalidCertificate();
        uint256 certId = hashDataToCertId[hashData];
        _updateCertificate(certId, newCertHash, newDurationInYears, receiver);
    }

    function _updateCertificate(uint256 certId, string calldata newCertHash, uint256 newDurationInYears, address receiver) internal {
        Certificate storage certificate = certificates[certId];
        bytes memory hashData = abi.encodePacked(newCertHash);
        if(keccak256(hashData) != keccak256(abi.encodePacked(""))) certificate.hashData = hashData;
        if(newDurationInYears > 0) certificate.activeUntil = uint64(_handleCertificateDuration(newDurationInYears, certificate.activeUntil));
        if(receiver != address(0)) _transfer(msg.sender, receiver, certId);
        emit CertUpdated(certId, certificate.hashData, ownerOf(certId));
    }

    function setIssuer(address _entity, bool _isIssuer) public onlyOwner {
        _setIssuer(_entity, _isIssuer);
    }

    function _handleCertificateDuration(uint256 durationInYears, uint256 startingTimestamp) internal view returns(uint256 activeUntil){
        uint currentTimestamp = block.timestamp;
        if(currentTimestamp > PROTOCOL_LIFETIME) revert BlockedCert__ProtocolEnded();
        uint256 duration = durationInYears * YEAR;
        activeUntil = duration + startingTimestamp;
        if(duration < MINIMUM_DURATION) revert BlockedCert__InvalidDuration(durationInYears);
        if(activeUntil > PROTOCOL_LIFETIME) activeUntil = PROTOCOL_LIFETIME;
        if(activeUntil < currentTimestamp) revert BlockedCert__PastTime(activeUntil);
    }

    function burnCertificateById(uint256 certId) external onlyIssuer  {
        if (certId > nextCertId || !_exists(certId)) revert BlockedCert__InvalidCertificate();
        _authBurn(certId);
    }

    function burnCertificateByHash(string memory certHash) external onlyIssuer {
        bytes memory hashData = abi.encodePacked(certHash);
        if (!hashDataExists[hashData]) revert BlockedCert__InvalidCertificate();
        uint256 certId = hashDataToCertId[hashData];
        _authBurn(certId);
    }

    function _authBurn(uint256 certId) internal override {
        Certificate storage certificate = certificates[certId];
        delete hashDataExists[certificate.hashData];
        delete hashDataToCertId[certificate.hashData];
        delete certificates[certId];
        super._authBurn(certId);
        emit CertBurned(certId);
    }
    
}