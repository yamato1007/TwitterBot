module Application where

import Operations
import Util
import Settings
import qualified API as API

tweetWithPrint :: String -> IO ()
tweetWithPrint t = do
  postTweet t >>= dustBox
  putStrLn $ "Tweeted : " ++ t

tweetUsual :: IO ()
tweetUsual = do
  tweets <- readFileLn tweetUsualFile
  tweet <- randChoice tweets 
  tweetWithPrint tweet

printTweets :: String -> IO ()
printTweets usr = do
  ets <- getTweets usr :: TResponse [API.Tweet] 
  (mapM_ . mapM_) (putStrLn.API.text) ets

printMentions :: IO ()
printMentions = do
  ets <- getMentions :: TResponse [API.Tweet] 
  (mapM_ . mapM_) (putStrLn.API.text) ets

tweetAtTime :: IO ()
tweetAtTime = do 
  time <- getTimeFormat "%H:%M"
  tm <- mapFromFile tweetAtTimeFile
  mapM_ tweetWithPrint $ lookup time tm 

reply :: IO ()
reply = do
  latest <- readFile latestMentionFile
  mentions <- twitterRequest API.mentions_timeline [("since_id",latest)] :: TResponse [API.Tweet]
  replyMap <- mapFromFile replyFile
  mapM_ (replyToTweets replyMap) mentions
  mapM_ (writeFile latestMentionFile) $ fmap API.id_str (mentions >>= headEither)

replyToTweets :: [(String,String)] -> [API.Tweet] -> IO ()
replyToTweets replyMap mentions = mapM_ (replyToTweet replyMap) mentions

replyToTweet :: [(String,String)] -> API.Tweet -> IO ()
replyToTweet replyMap mention = do
  let (id,user) = (API.id_str mention, API.screen_name $ API.user mention)
  let text = head $ (lookupRegex replyMap) (API.text mention)
  let status = '@':user ++ ' ':text
  twitterRequest' API.update [("in_reply_to_status_id",id),("status",status)]
  putStrLn $ "Tweeted : " ++ status

