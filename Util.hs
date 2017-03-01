module Util where

import System.Random
import qualified Data.ByteString as B
import Codec.Binary.UTF8.String as Codec
import Data.Time
import Text.Regex.Posix
import qualified Codec.Binary.UTF8.String as U

randChoice :: [a] -> IO a
randChoice l = do
  r <- randomRIO (0, 1) :: IO Double
  let n = floor $ r * (fromIntegral $ length l)
  return $ l !! n

strToB :: String -> B.ByteString
strToB s = B.pack $ Codec.encode s

bToStr :: B.ByteString -> String
bToStr b = Codec.decode $ B.unpack b

getTimeFormat :: String -> IO String
getTimeFormat f = fmap (formatTime defaultTimeLocale f ) getZonedTime

separate :: Char -> String -> [String]
separate c s = foldr check [[]] s
  where
    check c' (s:ss) = if c' == c then []:s:ss else (c':s):ss

lookupRegex :: [(String,String)] -> String -> [String]
lookupRegex m s = foldr match [] m 
  where 
    match (k,v) l = if U.encodeString s =~ (U.encodeString k :: String) then v:l else l

mapFromFile :: String -> IO [(String,String)]
mapFromFile file = do
  ls <- readFileLn file
  return $ fmap (\(a:b:_) -> (a,b)) $ fmap (separate ',') ls

readFileLn :: String -> IO [String]
readFileLn file = fmap lines $ readFile file

headMaybe :: [a] -> Maybe a
headMaybe [] = Nothing
headMaybe (a:_) = Just a

headEither :: [a] -> Either String a
headEither [] = Left "List is Empty"
headEither (a:_) = Right a
