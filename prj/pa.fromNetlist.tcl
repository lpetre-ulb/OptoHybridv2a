
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name OptoHybrid_v2 -dir "/home/user/OptoHybridv2a/prj/planAhead_run_1" -part xc6vlx130tff1156-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/user/OptoHybridv2a/prj/optohybrid_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/user/OptoHybridv2a/prj} {../src/ip_cores} {../src/tdc/ip_cores} }
add_files [list {../src/ip_cores/chipscope_vio.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo_bx.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo_request_rx.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo32x32.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/chipscope_icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/sem.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo_tracking.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/chipscope_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo256x32.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/ip_cores/fifo_request_tx.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/tdc/ip_cores/ram512x15.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/tdc/ip_cores/ram512x12.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../src/tdc/ip_cores/fifo512x32.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "/home/user/OptoHybridv2a/src/ucf/misc.ucf" [current_fileset -constrset]
add_files [list {/home/user/OptoHybridv2a/src/ucf/clocking.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/user/OptoHybridv2a/src/ucf/gtx.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/user/OptoHybridv2a/src/ucf/memory.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/user/OptoHybridv2a/src/ucf/misc.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/user/OptoHybridv2a/src/gtx/gtx_attributes.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/user/OptoHybridv2a/src/ucf/vfat2_v2a.ucf}] -fileset [get_property constrset [current_run]]
link_design
