// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedCertificate {

    // Struct to store certificate details
    struct Certificate {
        string studentName;
        string certificateType;
        string issuingBody;
        uint256 issueDate;
        bool isValid;
    }

    // Mapping to store certificates by a unique certificate ID (e.g., a hash or counter)
    mapping(uint256 => Certificate) public certificates;

    // Event to log the issuance of a new certificate
    event CertificateIssued(uint256 certificateId, string studentName, string certificateType, string issuingBody, uint256 issueDate);

    // Function to issue a new certificate
    function issueCertificate(
        uint256 certificateId,
        string memory studentName,
        string memory certificateType,
        string memory issuingBody
    ) public {
        require(bytes(studentName).length > 0, "Student name is required");
        require(bytes(certificateType).length > 0, "Certificate type is required");
        require(bytes(issuingBody).length > 0, "Issuing body is required");

        // Store certificate details in the mapping
        certificates[certificateId] = Certificate({
            studentName: studentName,
            certificateType: certificateType,
            issuingBody: issuingBody,
            issueDate: block.timestamp,
            isValid: true
        });

        // Emit an event for transparency
        emit CertificateIssued(certificateId, studentName, certificateType, issuingBody, block.timestamp);
    }

    // Function to verify the certificate's authenticity
    function verifyCertificate(uint256 certificateId) public view returns (bool, string memory, string memory, string memory, uint256) {
        Certificate memory cert = certificates[certificateId];

        // Check if the certificate is valid
        if (cert.isValid) {
            return (true, cert.studentName, cert.certificateType, cert.issuingBody, cert.issueDate);
        } else {
            return (false, "", "", "", 0);
        }
    }

    // Function to revoke a certificate
    function revokeCertificate(uint256 certificateId) public {
        Certificate storage cert = certificates[certificateId];
        require(cert.isValid, "Certificate is already invalid");
        
        // Mark the certificate as invalid
        cert.isValid = false;
    }
}