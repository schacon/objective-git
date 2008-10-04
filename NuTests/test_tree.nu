(load "NuTests/helper")

(class TestGITTree is NuTestCase
     ;; helper functions
     (repo_helper)
     
     (set treeSha "df124a581fea0c1848a2a1672e3d0e1240251efe")
     
     (- test_create_tree_with_object is
          (set repo (self bareRepo))
          (set o (repo objectFromSha:treeSha))
          (set tree (GITTree treeWithGitObject:o))
          (assert_true ((tree gitObject) isEqualToObject:o)))
     
     (- test_tree_entries is
          (set repo (self bareRepo))
          ;(set commit (repo commitFromSha:headSha))
          ;(set treeSha (commit treeSha))
          (set o (repo objectFromSha:treeSha))
          (set tree (GITTree treeWithGitObject:o))
          (set entries (tree treeEntries))
          
          (set expectedEntries 
               (array
                    (array "100644" "goodbye.txt" "1f8cd80b2487916eff4f8011064357a45a258029")
                    (array "100644" "hello.txt"   "f018ccb5182ac1a9ec5ac7f07980ba8484ad85bf")))
          
          (assert_equal (expectedEntries list) (entries list))
          ))