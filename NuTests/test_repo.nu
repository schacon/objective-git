(load "NuTests/helper")

(class TestGITRepo is NuTestCase
     ;; helper functions
     (repo_helper)

     (- test_init_repo is
        (set repo GITRepo repoWithPath:testRepoPath error:nil)
        (assert_not_equal nil repo))
     
     (- test_init_bare_repo is
        (set repo (GITRepo repoWithPath:testBareRepoPath error:nil))
        (assert_not_equal nil repo))
     
     (- test_list_all_refs is
        (set repo (self bareRepo))
        (set expectedRefs (list (dict name:"HEAD" sha:headSha)
                                (dict name:"refs/heads/master" sha:headSha)))
        (set refs (repo refs))
        (set refsSet (NSSet setWithArray:refs))
        (assert_true (refsSet isEqualToSet:(NSSet setWithList:expectedRefs)))) 
     
     (- test_has_object_with_sha is
        (set repo (self bareRepo))
        (assert_true (repo hasObject:headSha))
        (assert_false (repo hasObject:"0000000000000000000000000000000000000000")))
     
     (- test_path_for_loose_object_with_sha is
        (set repo (self bareRepo))
        (set path (repo pathForLooseObjectWithSha:headSha))
        (assert_equal "NuTests/test_repo_bare_clone.git/objects/25/f6d2b5c50fb1624c3cf0d6ff5bfeb0772ebd68"
                      path)
        (assert_equal nil (repo pathForLooseObjectWithSha:"0")))
     
     (- test_object_with_sha is
        (set repo (self bareRepo))
        (set obj (repo objectFromSha:headSha))
        (assert_not_equal nil obj)
        (assert_equal headSha (obj sha)))
     
     (- test_commit_with_sha is
          (set repo (self bareRepo))
          (set commit (repo commitFromSha:headSha))
          (assert_not_equal nil commit)
          (assert_equal headSha (commit sha)))
     
     (- test_commits_with_sha is
          (set repo (self bareRepo))
          (set commits (repo commitsFromSha:headSha))
          (assert_equal 3 (commits count))
          (assert_equal headSha ((commits 0) sha))
          (assert_equal firstCommitSha ((commits lastObject) sha))
          (set two_commits (repo commitsFromSha:headSha limit:2))
          (assert_equal 2 (two_commits count))
          (assert_equal headSha ((two_commits 0) sha))))