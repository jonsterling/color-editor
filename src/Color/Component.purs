module Color.Component where

import Prelude

import Control.Apply ((*>))
import Control.Monad.Eff.Class (MonadEff)
import Data.Maybe (Maybe(..), maybe)
import Data.NaturalTransformation (Natural())
import Browser.WebStorage (WebStorage())

import qualified Css.Font (color) as Css

import Halogen
import Halogen.HTML.Core (ClassName(), className, prop, propName, attrName)
import qualified Halogen.HTML.Events.Indexed as E
import qualified Halogen.HTML.Indexed as H
import qualified Halogen.HTML.Properties.Indexed as P
import qualified Halogen.HTML.CSS.Indexed as C

import Halogen.Menu.Submenu.Model (Submenu(), SubmenuItem())
import Halogen.Menu.Submenu.Query (SubmenuQuery(..))

import Color.Model (Color(), save, load, fromString, toCssColor, increaseRed, increaseGreen, increaseBlue, decreaseRed, decreaseGreen, decreaseBlue)
import Color.Query (ColorQuery(..))

colorComponent :: forall g eff. (MonadEff (webStorage :: WebStorage | eff) g) => Component Color ColorQuery g
colorComponent = component render eval
  where

  render :: Color -> ComponentHTML ColorQuery
  render color =
    H.div
      [ P.class_ colorClass, C.style (Css.color $ toCssColor color) ]
      [ H.span_ [ H.text $ show color ] ]

  eval :: Natural ColorQuery (ComponentDSL Color ColorQuery g)
  eval (IncreaseRed next) = modify increaseRed *> pure next
  eval (DecreaseRed next) = modify decreaseRed *> pure next
  eval (IncreaseGreen next) = modify increaseGreen *> pure next
  eval (DecreaseGreen next) = modify decreaseGreen *> pure next
  eval (IncreaseBlue next) = modify increaseBlue *> pure next
  eval (DecreaseBlue next) = modify decreaseBlue *> pure next
  eval (LoadColor next) = (liftEff' load >>= maybe (pure unit) (const >>> modify)) *> pure next
  eval (SaveColor next) = (get >>= (save >>> liftEff')) *> pure next

  colorClass :: ClassName
  colorClass = className "ce-color"

