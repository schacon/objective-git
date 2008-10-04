(load "NuTests/helper")

(class TestGITObject is NuTestCase
     ;; helper functions
     (repo_helper)

     (- test_create_with_raw_data is
          (set repo (self bareRepo))
          (set o (repo objectFromSha:headSha))
          (set compressedData ((o raw) compressedData))
          (set newObject ((GITObject alloc) initWithRaw:compressedData sha:headSha))
          (assert_true (o isEqualToObject:newObject)))
     
     (- test_contents is
          (set repo (self bareRepo))
          (set o (repo objectFromSha:headSha))
          (assert_true ((o contents) hasPrefix:"tree df124a58"))))