module Util where

import System.Random
import qualified Data.ByteString as B
import Codec.Binary.UTF8.String as Codec

randChoice :: [a] -> IO a
randChoice l = do
  r <- randomRIO (0, 1) :: IO Double
  let n = floor $ r * (fromIntegral $ length l)
  return $ l !! n

strToB :: String -> B.ByteString
strToB s = B.pack $ Codec.encode s

bToStr :: B.ByteString -> String
bToStr b = Codec.decode $ B.unpack b

