module Example.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Generic (class Generic, gShow)
import Data.Maybe (maybe)
import DOM (DOM)

import DOM.WebStorage (STORAGE, getItem, setItem, getLocalStorage)

-- 1. Define item types to store.
newtype UserConfig = UserConfig { name :: String, email :: String }
-- TODO: manually implement codecs formatted as "name <email>".
derive instance genericUserConfig :: Generic UserConfig

newtype ServerCache = ServerCache { lastModified :: Number, recentContacts :: Array UserConfig }
-- 2. Either implement EncodeJson and DecodeJson or derive Generic for (de)serialization.
derive instance genericServerCache :: Generic ServerCache

-- 3. Define keys as a "phantom type".
data ExampleKey a = UserConfigKey | ServerCacheKey
derive instance genericExampleKey :: Generic (ExampleKey a)

-- 4. Make "smart constructor" for each key.
userConfigKey :: ExampleKey UserConfig
userConfigKey = UserConfigKey

serverCacheKey :: ExampleKey ServerCache
serverCacheKey = ServerCacheKey


{- 5. Optionally ask the tooth fairy for a GADT under your pillow.
data ExampleKey a where
  UserConfig :: ExampleKey UserConfig
  ServerCache :: ExampleKey ServerCache
-}

-- 6. Run in browser.
main :: Eff (console :: CONSOLE, storage :: STORAGE, dom :: DOM) Unit
main = do
  let userConfig = UserConfig { name : "PureScript", email : "purescript@example.com" }
  localStorage <- getLocalStorage
  setItem localStorage userConfigKey userConfig
  result <- getItem localStorage userConfigKey
  log $ maybe "Are you Private Browsing in Safari?" gShow result
