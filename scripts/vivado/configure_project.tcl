# Run this script to create the Vivado project files in the WORKING DIRECTORY
# If ::create_path global variable is set, the project is created under that path instead of the working dir

if {[info exists ::create_path]} {
    set dest_dir $::create_path
} else {
    set dest_dir [pwd]
}
puts "INFO: Creating new project in $dest_dir"

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir ".."

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/proj"]"

# Create project
create_project $proj_name $dest_dir

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]
set logiclib_dir $proj_dir/../../../logiclibrary
set iplib_dir $proj_dir/../../../iplibrary
set ipcore_dir $iplib_dir/ip_cores/$proj_name

# Set project properties
set obj [get_projects $proj_name]
set_property "default_lib" "work" $obj
set_property "part" "$part_num" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "Verilog" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
#set_property "ip_repo_paths" "[file normalize $repo_dir]" $obj
