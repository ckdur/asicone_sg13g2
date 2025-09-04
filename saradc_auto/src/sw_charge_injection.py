import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sys, os
import itertools

if __name__ == "__main__":
    voltages = np.linspace(0.0, 1.8, 10)
    voltages_str = ["{:.2f}".format(v) for v in voltages]
    delays = np.linspace(10, 20, 6)
    delays_str = ["{:.2f}p".format(v) for v in delays]

    name_gen = lambda v, d: "{}_{}".format(v, d)

    if len(sys.argv) <= 3:
        print("USAGE: {} run_dir template spice_cmd")
        sys.exit(1)
    
    run_dir = sys.argv[1]
    template = sys.argv[2]
    sim_cmd = sys.argv[3]

    # Read original content
    with open(template, "r") as f:
        content = f.read()

    for idx_volt, idx_delay in itertools.product(range(len(voltages)), range(len(delays))):
        volt = voltages_str[idx_volt]
        volt_str = voltages_str[idx_volt]
        delay = delays_str[idx_delay]
        delay_str = delays_str[idx_delay]
        name = name_gen(volt_str, delay_str)

        # Modify the content
        new_content = content.replace("{vdc}", volt_str)
        new_content = new_content.replace("{delay}", delay_str)
        new_content = new_content.replace("sw_charge_injection.xyce", "sw_charge_injection.xyce."+name)
        new_content = new_content.replace("mos_tt", "mos_tt")

        netlist_path = "{}/sw_charge_injection.xyce.{}.sp".format(run_dir, name)

        # Overwrite with modified content
        with open(netlist_path, "w") as f:
            f.write(new_content)

        # Do the simulation
        cmd = "cd {} && {} {}".format(run_dir, sim_cmd, netlist_path)
        print("Running: ", cmd)
        os.system(cmd)

        # Load simulation data
        df = pd.read_csv("{}/sw_charge_injection.xyce.{}.csv".format(run_dir, name))

        t = df["TIME"].to_numpy()
        CS = df["V(CS)"].to_numpy()
        NCS = df["V(NCS)"].to_numpy()
        VOv4 = df["V(VOV4)"].to_numpy()
        VOv5 = df["V(VOV5)"].to_numpy()
        VOnd = df["V(VOND)"].to_numpy()
        VOnd2 = df["V(VOND2)"].to_numpy()
        VOnd3 = df["V(VOND3)"].to_numpy()
        VOclassicideal = df["V(VOCLASSICIDEAL)"].to_numpy()
        VOclassic2 = df["V(VOCLASSIC2)"].to_numpy()
        VO1videal = df["V(VO1VIDEAL)"].to_numpy()
        VO2videal = df["V(VO2VIDEAL)"].to_numpy()

        fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(6, 5), sharex=True)
        ax1.plot(t, CS, color="blue")
        ax1.plot(t, NCS, color="red")
        ax1.set_ylabel("Time (s)")
        ax1.set_xlabel("Voltage (V)")
        ax1.set_title("CS & NCS")
        
        ax2.plot(t, VOv4, color="blue")
        ax3.plot(t, VOv5, color="blue")

        plt.show()
