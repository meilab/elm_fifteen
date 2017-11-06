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
        , renderControlPanel model.status model.directions
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
                            "dark-tile dark-button"

                        _ ->
                            "light-tile light-button"
            in
                div
                    [ class tileClass
                    , onClick (TileClicked tile ( row, column ))
                    ]
                    [ text (toString tile) ]


renderControlPanel : GameStatus -> List Direction -> Html Msg
renderControlPanel status directions =
    case status of
        Playing ->
            let
                undoClass =
                    case directions of
                        [] ->
                            "disabled-button dark-button"

                        _ ->
                            "control-button dark-button"
            in
                div [ class "controller-container" ]
                    [ div
                        [ class "control-button dark-button"
                        , onClick Replay
                        ]
                        [ text "Replay" ]
                    , div
                        [ class undoClass
                        , onClick Undo
                        ]
                        [ text "Undo" ]
                    , div
                        [ class "control-button dark-button"
                        , onClick Solve
                        ]
                        [ text "Solve" ]

                    {-
                       , div []
                           [ label [] [ text "change dimension dark-button" ]
                           , input [ onInput ChangeDimension ] [ text "hello" ]
                           ]
                    -}
                    ]

        Solving ->
            div [ class "controller-container" ]
                [ text "solving, have fun:)"

                {-
                   , button
                       [ class "control-button dark-button"
                       , onClick Replay
                       ]
                       [ text "Play Again" ]
                -}
                ]

        ShowSolver ->
            div [ class "controller-container" ]
                [ div
                    [ class "control-button dark-button"
                    , onClick Replay
                    ]
                    [ text "Replay" ]
                , div
                    [ class "control-button dark-button"
                    , onClick Pause
                    ]
                    [ text "Pause" ]
                ]

        Paused ->
            div [ class "controller-container" ]
                [ div
                    [ class "control-button dark-button"
                    , onClick Replay
                    ]
                    [ text "Replay" ]
                , div
                    [ class "control-button dark-button"
                    , onClick ResumePlaySolverResult
                    ]
                    [ text "Resume" ]
                ]

        Finished ->
            div [ class "controller-container" ]
                [ div [ class "victory" ]
                    [ h3 [ class "victory-title" ] [ text "YOU WIN" ]
                    , button
                        [ class "control-button dark-button"
                        , onClick Replay
                        ]
                        [ text "Play Again" ]
                    ]
                ]
