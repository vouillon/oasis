
(** Executable schema and generator
    @author Sylvain Le Gall
  *)

open OASISTypes;;
open OASISSchema;;
open OASISValueParser;;
open CommonGettext;;
open PropList.Field;;

let schema, generator =
  let schm =
    schema "executable" 
  in
  let main_is =
    new_field schm "MainIs" 
      (fun vl ->
         str_regexp
           (Str.regexp ".*\\.ml$")
           (s_ ".ml file")
           (file vl))
      (fun () -> 
         s_ "OCaml file (.ml) containing main procedure for the executable.")
  in
  let custom =
    new_field schm "Custom"
      ~default:false
      boolean
      (fun () ->
         s_ "Create custom bytecode executable.")
  in
  let build, install, compiled_object = 
    OASISUtils.std_field (s_ "executable") Byte schm
  in
  let build_depends, build_tools =
    OASISUtils.depends_field schm
  in
  let c_sources = 
    OASISUtils.c_field schm
  in
  let data_files =
    OASISUtils.data_field schm
  in
    schm,
    (fun nm data -> 
       {
         exec_build           = build data;
         exec_install         = install data;
         exec_main_is         = main_is data;
         exec_compiled_object = compiled_object data;
         exec_build_depends   = build_depends data;
         exec_build_tools     = build_tools data;
         exec_c_sources       = c_sources data;
         exec_custom          = custom data;
         exec_data_files      = data_files data;
         exec_is              = FilePath.concat 
                                  (FilePath.dirname (main_is data))
                                  nm;
         exec_schema_data     = data;
       })
;;

