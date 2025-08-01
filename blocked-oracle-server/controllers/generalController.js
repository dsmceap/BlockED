exports.getOracleAddress = async (req, res) => {
    return res.status(200).json({
        message: 'Oracle account address',
        result: process.env.ACCOUNT_ADDRESS
    });
};

exports.getContractAddress = async (req, res) => {
    return res.status(200).json({
        message: 'BlockedCert contract address',
        result: process.env.CONTRACT_ADDRESS
    });
};