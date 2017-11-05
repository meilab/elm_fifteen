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
        [ (renderBoard model.board model.dimension)
        , renderControlPanel model.status
        ]


renderBoard : Board -> Int -> Html Msg
renderBoard board dimension =
    div
        [ class "board"
        , style (Styles.board dimension)
        ]
        (map (renderRow board dimension) (range 1 dimension))


renderRow : Board -> Int -> Row -> Html Msg
renderRow board dimension row =
    div
        [ class "row"
        ]
        (map (renderTile board dimension row) (range 1 dimension))


renderTile : Board -> Int -> Row -> Column -> Html Msg
renderTile board dimension row column =
    case get ( row, column ) board of
        Nothing ->
            div [ class "hole" ] []

        Just tile ->
            let
                tileClass =
                    case tile % 2 of
                        0 ->
                            "dark-tile"

                        _ ->
                            "light-tile"
            in
                div
                    [ class tileClass
                    , onClick (TileClicked tile ( row, column ))
                    ]
                    [ text (toString tile) ]


renderControlPanel : GameStatus -> Html Msg
renderControlPanel status =
    case status of
        Playing ->
            div [ class "controller" ]
                [ div
                    [ class "replay-button"
                    , onClick Replay
                    ]
                    [ text "Replay" ]
                , div
                    [ class "undo-button"
                    , onClick Undo
                    ]
                    [ text "Undo" ]
                , div
                    [ class "solve-button"
                    , onClick Resolve
                    ]
                    [ text "Solve" ]

                {-
                   , div []
                       [ label [] [ text "change dimension" ]
                       , input [ onInput ChangeDimension ] [ text "hello" ]
                       ]
                -}
                ]

        Solving ->
            div [ class "controller" ]
                [ text "solving"
                , button
                    [ class "replay-button"
                    , onClick Replay
                    ]
                    [ text "Play Again" ]
                ]

        ShowSolver ->
            div [ class "controller" ]
                [ div
                    [ class "replay-button"
                    , onClick Replay
                    ]
                    [ text "Replay" ]
                ]

        Finished ->
            div [ class "controller" ]
                [ div [ class "victory" ]
                    [ h3 [ class "victory-title" ] [ text "YOU WIN" ]
                    , button
                        [ class "replay-button"
                        , onClick Replay
                        ]
                        [ text "Play Again" ]
                    ]
                ]
