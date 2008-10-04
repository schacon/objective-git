;;
;; Nukefile for ObjectiveGit
;;
;; Commands:
;;	nuke 		- builds TouchJSON as a framework
;;	nuke test	- runs the unit tests in the NuTests directory
;;	nuke install	- installs TouchJSON in /Library/Frameworks
;;	nuke clean	- removes build artifacts
;;	nuke clobber	- removes build artifacts and TouchJSON.framework
;;
;; The "nuke" build tool is installed with Nu (http://programming.nu)
;;

;; the @variables below are instance variables of a NukeProject.
;; for details, see tools/nuke in the Nu source distribution.

;; source files
(set @m_files     (filelist "^src/.*.m$"))
(set @c_files     (filelist "^src/.*.c$"))

;; framework description
(set @framework "ObjectiveGit")
(set @framework_identifier   "com.yourcompany.ObjectiveGit")
(set @framework_creator_code "????")
(set @framework_install_path "@executbale_path/../Frameworks")

(set @public_headers (filelist "^src/GIT.*.h$"))
(@public_headers unionSet:(filelist "^src/#{@framework}.h"))

(set @cflags "-g -I src")
(set @ldflags "-lz -framework Foundation")

(compilation-tasks)
(framework-tasks)

;; Copying framework headers seems to be missing from Nu - add it here for now...
(task "copy_framework_headers" => @framework_headers_dir)
(@public_headers each:
     (do (h)
         (set filename (h lastPathComponent))
         (set targetFile (@framework_headers_dir stringByAppendingPathComponent:filename))
         (set sourceFile h)
         (file targetFile => h is
               (SH "cp -p '#{sourceFile}' '#{targetFile}'"))
         (task "copy_framework_headers" => targetFile @framework_headers_dir)))
(task "framework" => "copy_framework_headers")


;; Standard tasks
(task "clobber" => "clean" is
      (SH "rm -rf #{@framework_dir}")
      (SH "rm -rf build")) ;; @framework_dir is defined by the nuke framework-tasks macro

(task "default" => "framework")

(task "install" => "framework" is
      (SH "sudo rm -rf /Library/Frameworks/#{@framework}.framework")
      (SH "ditto #{@framework}.framework /Library/Frameworks/#{@framework}.framework"))

(task "test" => "framework" is
      (SH "nutest NuTests/test_*.nu"))
