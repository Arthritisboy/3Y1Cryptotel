// const Web3 = require('web3');
// const WalletConnectProvider = require('@walletconnect/web3-provider');
// const { BadRequestError } = require('../errors');

// // Replace with your Infura Project ID
// const INFURA_PROJECT_ID = 'aa79fff789bb4054bf4174eeca2b893a';

// const connectToMetaMask = async (req, res) => {
//   try {
//     // Create WalletConnect provider with Infura
//     const provider = new WalletConnectProvider({
//       infuraId: INFURA_PROJECT_ID
//     });

//     // Enable session (this will open MetaMask)
//     await provider.enable();

//     // Create Web3 instance
//     const web3 = new Web3(provider);

//     // Check connection
//     await web3.eth.net.isListening();

//     res.status(200).json({ message: 'Connected to MetaMask via WalletConnect' });
//   } catch (error) {
//     console.error('Connection error:', error.message);
//     throw new BadRequestError('Failed to connect to MetaMask', 400);
//   }
// };

// module.exports = {
//   connectToMetaMask,
// };
