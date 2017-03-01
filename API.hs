module API where

type API = (Method,URL)

type URL = String
data Method = GET | POST deriving (Show,Eq)

user_timeline = (GET,"https://api.twitter.com/1.1/statuses/user_timeline.json")
update = (POST,"https://api.twitter.com/1.1/statuses/update.json")
