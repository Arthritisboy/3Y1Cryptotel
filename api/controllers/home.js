// const Web3 = require('web3');

// // Function to connect to MetaMask using WalletConnect
// const connectToMetaMask = async (req, res) => {
//   try {
//     // Connect using Infura (replace with your Infura project ID)
//     const provider = new Web3.providers.HttpProvider(
//       `https://mainnet.infura.io/v3/aa79fff789bb4054bf4174eeca2b893a`
//     );

//     const web3 = new Web3(provider);

//     // Get accounts (simulate MetaMask connection, adjust as needed for WalletConnect)
//     const accounts = await web3.eth.getAccounts();
//     const account = accounts[0];

//     if (!account) {
//       return res.status(400).json({ error: 'Failed to connect to MetaMask' });
//     }

//     // Return the MetaMask account to the Flutter client
//     res.status(200).json({ account });
//   } catch (error) {
//     return res.status(500).json({ error: 'An error occurred while connecting to MetaMask' });
//   }
// };

// Function to handle the home page route
const getHome = (req, res) => {
  res.status(200).json({
    message: 'Welcome to the Home Page',
    user: req.user, // Assuming user info is attached to the request via middleware
  });
};

module.exports = {
  // connectToMetaMask,
  getHome
};