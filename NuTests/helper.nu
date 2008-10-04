;; Test Helper functions/methods/var declarations

;; load library
(load "ObjectiveGit")

(set CFUUIDCreate (NuBridgedFunction functionWithName:"CFUUIDCreate" signature:"@@"))
(set CFUUIDCreateString (NuBridgedFunction functionWithName:"CFUUIDCreateString" signature:"@@@"))
(set NSTemporaryDirectory (NuBridgedFunction functionWithName:"NSTemporaryDirectory" signature:"@"))

(function tmp-dir ()
     (set uuid (CFUUIDCreateString nil (CFUUIDCreate nil)))
     (NSTemporaryDirectory stringByAppendingPathComponent:uuid))
     
(macro repo_helper
     (set testRepoPath "NuTests/test_repo")
     (set testBareRepoPath "NuTests/test_repo_bare_clone.git")
     (set headSha "25f6d2b5c50fb1624c3cf0d6ff5bfeb0772ebd68")
     (set firstCommitSha "094f1f190d82c99857d8fb2968586be5594d288c")
     
     (- bareRepo is
          (GITRepo repoWithPath:testBareRepoPath error:nil)))