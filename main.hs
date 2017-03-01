{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE DeriveGeneric #-}

import Operations
import Util

tweetUsualFile = "tweetUsual.txt"

tweetUsual :: IO ()
tweetUsual = do
  tweets <- fmap lines $ readFile tweetUsualFile
  tweet <- randChoice tweets 
  postTweet tweet :: TResponse ()
  putStrLn $ "Tweeted : " ++ tweet
  return ()

printTweets :: String -> Int -> IO ()
printTweets usr n = do
  ets <- getTweets usr :: TResponse [Tweet] 
  let etsn = fmap (take n) ets 
  (mapM_ . mapM_) (putStrLn.text) etsn

main :: IO ()
main = do
  tweetUsual

