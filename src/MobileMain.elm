module MobileMain exposing (..)

import NativeUi as Ui exposing (Node)
import Models exposing (..)
import Messages exposing (Msg(..))
import Types exposing (..)
import Update exposing (update)
import MobileViews exposing (view)


-- VIEW


main : Program Never Model Msg
main =
    Ui.program
        { init = ( initModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
