module Snakes.Control where

import Graphics.Gloss
import Snakes.Config
import Snakes.Model

-- | Possible user actions.
data Action
  = RedirectSnake Point   -- ^ Point snake's head in a different direction.

handleAction :: Action -> Snake -> GameConfig -> Snake
handleAction (RedirectSnake pos) snake _ = snake { snakeTarget = Just pos }
