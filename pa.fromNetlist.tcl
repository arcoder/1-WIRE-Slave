
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name SEARCH_ROM -dir "C:/Users/alberto/Documents/Progetti/SUBPROJECT/SEARCH_ROM/planAhead_run_2" -part xc3s500efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/alberto/Documents/Progetti/SUBPROJECT/SEARCH_ROM/Interface.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/alberto/Documents/Progetti/SUBPROJECT/SEARCH_ROM} {ipcore_dir} }
add_files [list {ipcore_dir/ROM.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Interface.ucf" [current_fileset -constrset]
add_files [list {Interface.ucf}] -fileset [get_property constrset [current_run]]
link_design
