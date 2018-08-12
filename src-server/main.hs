{-# LANGUAGE OverloadedStrings #-}

import           Control.Exception         (SomeException, try)
import           Data.Maybe                (fromMaybe)
import           System.Environment        (getEnv)
import           Text.Read                 (readMaybe)

import           Network.HTTP.Types        (status200)
import           Network.HTTP.Types.Header (hContentType)
import           Network.Wai               (Application, responseLBS)
import           Network.Wai.Handler.Warp  (run)

main :: IO ()
main = do
  result <- try (getEnv "PORT") :: IO (Either SomeException String)
  let defaultPort = 5000
  let port =
        case result of
          Left exception -> defaultPort
          Right val      -> fromMaybe defaultPort (readMaybe val :: Maybe Int)

  putStrLn $ "Listening on port " ++ show port
  run port app

app :: Application
app req res =
  res $ responseLBS status200 [(hContentType, "text/html")] "<p>Hello world!</p>"
