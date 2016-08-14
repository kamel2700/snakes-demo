{-# LANGUAGE RecordWildCards #-}
module Snakes.Render where

import Data.Function ((&))
import Data.Monoid
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Snakes.Config
import Snakes.Model

renderUniverse :: Universe -> GameConfig -> Picture
renderUniverse Universe{..} cfg
    = renderFood (head uFood) cfg
   <> renderSnake uSnake cfg

renderSnake :: Snake -> GameConfig -> Picture
renderSnake snake cfg = foldMap (flip renderLink cfg) (snakeLinks snake)

renderLink :: Link -> GameConfig -> Picture
renderLink (x, y) GameConfig{..} = thickCircle r r
  & translate x y
  & color snakeColor
  where
    r = linkSize * 2/3

renderFood :: Food -> GameConfig -> Picture
renderFood Food{..} cfg@GameConfig{..}
  = (timeRing <>  item)
  & translate x y
  & color white
  where
    (x, y) = foodLocation
    timeRing = renderTimeout (foodTimeout / defaultFoodTimeout) foodSize
    item
      = renderItem foodSize 5
      & rotate (itemRotationRate * foodTimeout)

renderItem :: Float -> Int -> Picture
renderItem size n
  = polygon (take n (iterate (rotateV (2 * pi / fromIntegral n)) (0, r)))
  where
    r = 0.5 * size

renderTimeout :: Float -> Float -> Picture
renderTimeout x size
  = arc 0 (360 * x) size
  & rotate (-90)
