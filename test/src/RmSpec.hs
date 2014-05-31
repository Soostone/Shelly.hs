module RmSpec (rmSpec) where

import TestInit
import Help

rmSpec :: Spec
rmSpec = do
  let b = "b"
  describe "rm file" $ do
    it "rm" $ do
      res <- shelly $ do
        writefile b "testing"
        (True @==) =<< test_f b
        rm b
        test_f b
      assert (not res)

    it "rm_r" $ do
      res <- shelly $ do
        writefile b "testing"
        (True @==) =<< test_f b
        rm b
        test_f b
      assert $ not res

    it "rm_f" $ do
      res <- shelly $ do
        (False @==) =<< test_f b
        rm_f b
        test_f b
      assert $ not res

  describe "rm_rf dir" $ do
    let d = "dir"
    it "empty dir" $ do
      res <- shelly $ do
        mkdir d
        rm_rf d
        test_d d
      assert $ not res

    it "dir with file" $ do
      res <- shelly $ do
        mkdir d
        rm d `catchany_sh` (\_ -> return ())
        (True @==) =<< test_d d
        writefile (d </> b) "testing"
        rm d `catchany_sh` (\_ -> return ())
        (True @==) =<< test_d d
        rm_rf d
        test_d d
      assert $ not res
