# TwitterBot
This is a TwitterBot written by Haskell.

## description
This app can tweet random sentence, tweet at designated time, and reply.
If you want use it as a bot, you have to set configuration to cron.
This app tweet some sentence written on following files.

* tweetUsual.txt    
    * This app tweet a sentence which is randomly choosen from sentences written on this file. 
* tweetAtTime.txt
    * This app tweet at designated time.
      Tweeted sentence is written on this file.
* reply.txt
    * This app reply to other user's mention.
      Replyed sentence is choosen how it mutach regular expression. 
      Sentences and regular expression is written on this file.

## Stack
This project is maked by stack which is a cross-platform program for developing Haskell projects.
If you want execute this on your conputer, you have to install stack and do following commands.

* cd TwitterBot
* stack build
* stack exec TwitterBot
