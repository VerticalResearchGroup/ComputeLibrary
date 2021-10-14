# Set the reference directory for source file relative paths (by default the value is script directory path).
set proj_name "utils_tb"

# Set FPGA part number.
set part_num "xcvu9p-flga2104-2L-e"

source $::env(VCL_VIVADO_SCRIPTS)/configure_project.tcl

set src_dir $::env(VCL_UTIL_SRC)
set verif_dir $::env(VCL_UTIL_VERIF)

add_files -fileset sources_1 -quiet $src_dir/common

add_files -fileset sim_1 -quiet $verif_dir/common

set obj [get_filesets sources_1]
set_property top rr_arbiter $obj

set obj [get_filesets sim_1]
set_property top rr_arbiter_tb $obj
