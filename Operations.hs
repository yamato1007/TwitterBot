module Operations where

import qualified API as API
import Settings
import Util

import Web.Authenticate.OAuth
import Data.Text (Text)
import qualified Data.Text.IO as T
import qualified Data.ByteString as B
import Codec.Binary.UTF8.String as Codec
import Data.Aeson
import GHC.Generics
import Network.HTTP.Conduit

-- App Infomation

myOAuth :: IO OAuth
myOAuth = do 
  s <- fmap lines $ readFile appInfoFile
  let sb = fmap strToB s
  return $ newOAuth { oauthServerName = "api.twitter.com"
           , oauthConsumerKey = sb !! 0
           , oauthConsumerSecret = sb !! 1 }

myCred :: IO Credential
myCred = do 
  s <- fmap lines $ readFile appInfoFile
  let sb = fmap strToB s
  return $ newCredential (sb !! 2) (sb !! 3)


-- Define Synonyms for Data Type

type URL = String
type Option = [(String,String)]
type TResponse a = IO (Either String a)

-- Define Operations for Using Twitter API

dustBox :: Either String () -> IO ()
dustBox _ = return ()

postTweet :: FromJSON a => String -> TResponse a
postTweet tw = twitterRequest API.update [("status",tw)]
postTweet' tw = postTweet tw >>= dustBox

getMentions :: FromJSON a => TResponse a
getMentions = twitterRequest API.mentions_timeline []

getTweets :: FromJSON a => String -> TResponse a
getTweets name = twitterRequest API.user_timeline [("screen_name",name)]

twitterRequest :: FromJSON a => API.API -> Option -> TResponse a
twitterRequest (API.GET,url) opt = getRequest url opt
twitterRequest (API.POST,url) opt = postRequest url opt
twitterRequest' a o = twitterRequest a o >>= dustBox

postRequest :: FromJSON a => URL -> Option -> TResponse a
postRequest url opt = do
  req <- parseRequest url
  let reqWithOpt = urlEncodedBody (strOptToB opt) req
  authRequest reqWithOpt

getRequest :: FromJSON a => URL -> Option -> TResponse a
getRequest url opt = do
  let urlWithOpt = urlAddOpt opt url
  req <- parseRequest url
  authRequest req

authRequest :: FromJSON a => Request -> TResponse a
authRequest req = do
  o <- myOAuth
  c <- myCred
  signedReq <- signOAuth o c req
  m <- newManager tlsManagerSettings
  res <- httpLbs signedReq m
  return $ eitherDecode $ responseBody res

urlAddOpt :: Option -> URL -> URL
urlAddOpt [] url = url
urlAddOpt (o:opt) url = foldl urlAddOpt2 (urlAddOpt1 url o) opt
  where 
    urlAddOpt1 url (l,r) = url ++ '?':l ++ '=':r
    urlAddOpt2 url (l,r) = url ++ '&':l ++ '=':r

strOptToB :: Option -> [(B.ByteString, B.ByteString)]
strOptToB = map (\(l,r) -> (strToB l, strToB r))


