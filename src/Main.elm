module Main exposing (..)

import Messages exposing (Msg(..))
import Update exposing (update, init)
import Views exposing (view)
import Html
import Keyboard exposing (ups)
import Dict exposing (fromList, get)
import Types exposing (Model, GameStatus(..), Direction(..), UpdateDirectionCategory(..))
import Time exposing (Time)
import Utils exposing (cmd)


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        arrowKeys =
            fromList
                [ ( 37, Left )
                , ( 38, Up )
                , ( 39, Right )
                , ( 40, Down )
                ]

        keyPressed code =
            case get code arrowKeys of
                Just direction ->
                    DirectionMove direction PushDirection

                _ ->
                    OtherKeyPressed code
    in
        if model.status == ShowSolver then
            {-
               Debug.log ("Sub")
                   Time.every
                   Time.second
                   (always PlaySolverResult)
            -}
            Sub.none
        else if model.status == Playing then
            ups
                keyPressed
        else
            Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init 3
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
