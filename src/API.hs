{-# LANGUAGE DeriveGeneric #-}

module API where

import GHC.Generics
import Data.Aeson

-- Define API Data Type 
type API = (Method,URL)
type URL = String
data Method = GET | POST deriving (Show,Eq)

-- Define Data Type What is Encodable to/from JSON
data Tweet = Tweet { text :: !String,
                     id_str :: !String,
                     user :: User
                   } deriving (Show, Generic)
instance FromJSON Tweet
instance ToJSON Tweet

data User = User { screen_name :: !String } deriving (Show, Generic)
instance FromJSON User
instance ToJSON User

-- Define APIs
user_timeline = (GET,"https://api.twitter.com/1.1/statuses/user_timeline.json")
update = (POST,"https://api.twitter.com/1.1/statuses/update.json")
mentions_timeline = (GET,"https://api.twitter.com/1.1/statuses/mentions_timeline.json")
