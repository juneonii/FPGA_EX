# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\Chajunwon\FPGA_Ex\Project_0_Watch\Pj_0_Timer3\0_Pj_0_Timer3\0_Pj_0_Timer3_app_system\_ide\scripts\debugger_0_pj_0_timer3_app-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\Chajunwon\FPGA_Ex\Project_0_Watch\Pj_0_Timer3\0_Pj_0_Timer3\0_Pj_0_Timer3_app_system\_ide\scripts\debugger_0_pj_0_timer3_app-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Arty Z7 003017B7ED7BA" && level==0 && jtag_device_ctx=="jsn-Arty Z7-003017B7ED7BA-13722093-0"}
fpga -file C:/Users/Chajunwon/FPGA_Ex/Project_0_Watch/Pj_0_Timer3/0_Pj_0_Timer3/0_Pj_0_Timer3_app/_ide/bitstream/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/Chajunwon/FPGA_Ex/Project_0_Watch/Pj_0_Timer3/0_Pj_0_Timer3/design_1_wrapper/export/design_1_wrapper/hw/design_1_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Users/Chajunwon/FPGA_Ex/Project_0_Watch/Pj_0_Timer3/0_Pj_0_Timer3/0_Pj_0_Timer3_app/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Users/Chajunwon/FPGA_Ex/Project_0_Watch/Pj_0_Timer3/0_Pj_0_Timer3/0_Pj_0_Timer3_app/Debug/0_Pj_0_Timer3_app.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
