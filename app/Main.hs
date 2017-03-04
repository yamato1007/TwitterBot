module Main where

import Application

main :: IO ()
main = do
  tweetAtTime
  tweetUsual
  reply
  printTweets "_momoco__"
  printMentions
