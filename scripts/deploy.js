async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("deployer address", deployer.address)
  console.log("deployer balance", (await deployer.getBalance()).toString() / 1e18)
  const Waves = await hre.ethers.getContractFactory("WavePortal");
  const waves = await Waves.deploy({value: hre.ethers.utils.parseEther("0.1")});
  await waves.deployed();
  console.log("contract address", waves.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
