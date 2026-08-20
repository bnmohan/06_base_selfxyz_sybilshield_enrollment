// Frontend Environment Configuration for Self.xyz SybilShield Gateway
window.APP_CONFIG = {
  // Available Environments: Base Sepolia Testnet & Anvil Local Node
  NETWORKS: {
    // Base Sepolia Testnet (Chain ID 84532 / 0x14a34)
    "0x14a34": {
      CHAIN_ID: "0x14a34",
      CHAIN_NAME: "Base Sepolia Testnet",
      RPC_URL: "https://base-sepolia-rpc.publicnode.com",
      BLOCK_EXPLORER: "https://sepolia.basescan.org",
      CONTRACT_ADDRESS: "0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4"
    },
    // Anvil Local Node / Fork (Chain ID 31337 / 0x7a69)
    "0x7a69": {
      CHAIN_ID: "0x7a69",
      CHAIN_NAME: "Anvil Local Node",
      RPC_URL: "http://127.0.0.1:8545",
      BLOCK_EXPLORER: "https://sepolia.basescan.org",
      CONTRACT_ADDRESS: "0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4"
    }
  }
};

// Dynamic network resolver (parses URL query ?network=anvil vs ?network=sepolia or connected wallet chainId)
window.getActiveNetwork = function(chainId) {
  // 1. Check URL parameter (?network=anvil vs ?network=sepolia)
  if (typeof window !== 'undefined' && window.location && window.location.search) {
    const urlParams = new URLSearchParams(window.location.search);
    const netParam = (urlParams.get('network') || '').toLowerCase();
    if (netParam === 'anvil' || netParam === 'local' || netParam === '31337') {
      return window.APP_CONFIG.NETWORKS["0x7a69"];
    }
    if (netParam === 'sepolia' || netParam === 'base' || netParam === '84532') {
      return window.APP_CONFIG.NETWORKS["0x14a34"];
    }
  }

  // 2. Check Chain ID provided by connected wallet
  if (chainId) {
    const cid = chainId.toString().toLowerCase();
    if (cid === '0x14a34' || cid === '84532') {
      return window.APP_CONFIG.NETWORKS["0x14a34"];
    }
    if (cid === '0x7a69' || cid === '31337' || cid === '0x539' || cid === '1337') {
      return window.APP_CONFIG.NETWORKS["0x7a69"];
    }
  }

  // 3. Default fallback to Base Sepolia
  return window.APP_CONFIG.NETWORKS["0x14a34"];
};
