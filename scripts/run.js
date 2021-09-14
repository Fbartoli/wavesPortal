async function main() {
  const [owner, User] = await ethers.getSigners();
  const Waves = await hre.ethers.getContractFactory("WavePortal");
  const waves = await Waves.deploy({value: hre.ethers.utils.parseEther("0.1")});
  await waves.deployed();

  console.log("waves deployed to:", waves.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(waves.address)
  console.log("Contract Balance: ",hre.ethers.utils.formatEther(contractBalance))
  let count = await waves.getTotalWaves();
  let waveTxn = await waves.wave("YO");
  console.log('wut ?:', await waveTxn.wait());
  count = await waves.getTotalWaves();
  waveTxn = await waves.connect(User).wave("Hello");
  await waveTxn.wait();
  waveTxn = await waves.connect(User).wave("Hello");
  await waveTxn.wait();
  await waves.connect(User).getTotalWavesByUser();
  await waves.connect(User).whenUserWavedFirstTime();
  await waves.getTotalWaves();
  console.log('test',await waves.getWaversData());
  let allWaves = await waves.getAllWaves();
  console.log(allWaves)
  contractBalance = await hre.ethers.provider.getBalance(waves.address)
  console.log("Contract Balance: ",hre.ethers.utils.formatEther(contractBalance))
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
