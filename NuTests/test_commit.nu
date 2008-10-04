(load "NuTests/helper")

(class TestGITCommit is NuTestCase
     ;; helper functions
     (repo_helper)
     
     (- firstCommit is
          (set repo (self bareRepo))
          (repo commitFromSha:firstCommitSha))
     
     (- test_create_with_object is
          (set repo (self bareRepo))
          (set o (repo objectFromSha:headSha))
          (set commit (GITCommit commitWithGitObject:o))
          (assert_true ((commit gitObject) isEqualToObject:o)))
     
     (- test_message is
          (set commit (self firstCommit))
          (assert_equal "added hello world file\n" (commit message)))
     
     (- test_author is
          (set commit (self firstCommit))
          (set author (commit author))          
          (assert_equal "Brian Chapados" (author "name"))
          (assert_equal "chapados@sciencegeeks.org" (author "email"))
          (assert_equal "2008-10-03 12:09:31 -0700" ((author "date") description))))