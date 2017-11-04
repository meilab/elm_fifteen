module Update exposing (..)

import Models exposing (..)
import Messages exposing (Msg(..))
import Types exposing (..)
import Random exposing (generate)
import Board exposing (..)
import Solver exposing (..)
import Task
import Set
import Dict exposing (Dict, toList)
import Utils exposing (delay, cmd)
import Time exposing (Time)


init : Int -> ( Model, Cmd Msg )
init dimension =
    ( (initModel dimension), generate BoardGenerated (randomBoard dimension) )



--( initModel dimension, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardGenerated board ->
            if isSolvable board model.dimension && not (isFinished board model.dimension) then
                let
                    holeCoord =
                        findHole model.dimension board

                    distance =
                        boardDistance board model.dimension
                in
                    ( { model
                        | board = board
                        , status = Playing
                        , holeCoord = holeCoord
                        , distance = distance
                      }
                    , Cmd.none
                    )
            else
                init model.dimension

        Replay ->
            init model.dimension

        ChangeDimension dimension ->
            init (Result.withDefault 4 (String.toInt dimension))

        DirectionMove direction category ->
            let
                newModel =
                    updateModel model direction category
            in
                ( newModel, Cmd.none )

        TileClicked tile coord ->
            case findAdjacentHole model.board model.dimension coord of
                Nothing ->
                    ( model, Cmd.none )

                Just holeCoord ->
                    let
                        newBoard =
                            model.board |> moveTile tile coord holeCoord

                        newHoleCoord =
                            coord

                        newDistance =
                            model.distance - (manhattan newHoleCoord tile model.dimension) + (manhattan model.holeCoord tile model.dimension)
                    in
                        ( { model
                            | board = newBoard
                            , status = verify newBoard model.dimension
                            , holeCoord = newHoleCoord
                            , distance = newDistance
                            , moves = model.moves + 1
                          }
                        , Cmd.none
                        )

        Recall ->
            case List.head model.directions of
                Just direction ->
                    ( model, delay (Time.second * 2) <| DirectionMove (opposite direction) PopDirection )

                Nothing ->
                    ( model, Cmd.none )

        Resolve ->
            ( { model | status = Solving }
            , Task.attempt
                SolutionFound
                (findSolution { model | moves = 0, directions = [] }
                    (boardDistance model.board model.dimension)
                    upperBound
                    (Set.singleton (toList model.board))
                )
            )

        {-
           case
               findSolution { model | moves = 0, directions = []} (boardDistance model.board module.dimension) upperBound
           of
               Nothing ->
                   ( model, Cmd.none )

               Just value ->
                   let
                       newStatus =
                           ShowSolver
                   in
                       ( { model | status = newStatus, directions = value.directions }, Cmd.none )
        -}
        SolutionFound (Ok directions) ->
            Debug.log (toString (directions))
                ( { model | status = ShowSolver, directions = directions }, delay Time.second <| PlaySolverResult )

        SolutionFound (Err error) ->
            Debug.log ("Failed to solve")
                ( model, Cmd.none )

        PlaySolverResult ->
            case List.head model.directions of
                Just direction ->
                    ( model
                    , Cmd.batch
                        [ cmd (DirectionMove direction PopDirection)
                        , delay Time.second <| PlaySolverResult
                        ]
                    )

                Nothing ->
                    Debug.log ("Solver Finished")
                        ( { model | status = Finished }, Cmd.none )

        _ ->
            ( model, Cmd.none )
