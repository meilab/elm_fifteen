module Views exposing (view)

import Html exposing (Html, div, text, h3, button, input, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, style)
import Messages exposing (Msg(..))
import List exposing (range, map, concatMap, append, filter, foldr)
import Dict exposing (get)
import Types exposing (..)
import Styles


view : Model -> Html Msg
view model =
    div [ style (Styles.container model.dimension) ]
        ([ (renderBoard model.board model.dimension) ] ++ (renderFinishedScreen model.status))


renderBoard : Board -> Int -> Html Msg
renderBoard board dimension =
    div []
        (concatMap (renderRow board dimension) (range 1 dimension))


renderRow : Board -> Int -> Row -> List (Html Msg)
renderRow board dimension row =
    append
        (map (renderTile board row) (range 1 dimension))
        [ div [ class "line-break" ] [] ]


renderTile : Board -> Row -> Column -> Html Msg
renderTile board row column =
    case get ( row, column ) board of
        Nothing ->
            div [ class "hole" ] []

        Just tile ->
            div
                [ class "tile"
                , onClick (TileClicked tile ( row, column ))
                ]
                [ text (toString tile) ]


renderFinishedScreen : GameStatus -> List (Html Msg)
renderFinishedScreen status =
    case status of
        Playing ->
            [ div [ onClick Recall ] [ text "Recall" ]
            , div [ onClick Resolve ] [ text "Resolve" ]
            , div []
                [ label [] [ text "change dimension" ]
                , input [ onInput ChangeDimension ] [ text "hello" ]
                ]
            ]

        Finished ->
            [ div [ class "victory" ]
                [ h3 [ class "victory-title" ] [ text "YOU WIN" ]
                , button
                    [ class "replay-button"
                    , onClick Replay
                    ]
                    [ text "Play Again" ]
                ]
            ]

        _ ->
            [ div []
                [ text "solve"
                , button
                    [ class "replay-button"
                    , onClick Replay
                    ]
                    [ text "Play Again" ]
                ]
            ]
