import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MicjohnModule = buildModule("MicjohnModule", (m) => {

    const staking = m.contract("StakingContract");

    return { staking };
});

export default MicjohnModule;