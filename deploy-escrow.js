const hre = require("hardhat");

async function main() {
  const [buyer, seller, arbiter] = await hre.ethers.getSigners();

  const Escrow = await hre.ethers.getContractFactory("EscrowV2");
  const escrow = await Escrow.deploy(seller.address, arbiter.address, {
    value: hre.ethers.parseEther("1.0")
  });

  await escrow.waitForDeployment();
  console.log("Escrow V2 (Arbiter-mediated) deployed to:", await escrow.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
