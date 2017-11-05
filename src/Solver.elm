module Solver exposing (..)

import Types exposing (..)
import Board exposing (..)
import Dict exposing (Dict, fromList, toList, insert, get, remove, values)
import List exposing (concatMap, filter, length, map, map2, range, foldr, foldl)
import Set exposing (Set)
import Task


upperBound : Int
upperBound =
    100


verify : Board -> Int -> GameStatus -> GameStatus
verify board dimension curStatus =
    if isFinished board dimension then
        Finished
    else
        curStatus


manhattan : Coord -> Tile -> Int -> Int
manhattan ( row, column ) tile dimension =
    let
        rowDist =
            abs (row - 1 - (tile - 1) // dimension)

        colDist =
            abs (column - 1 - (tile - 1) % dimension)
    in
        if tile == 0 then
            0
        else
            rowDist + colDist



-- Hamming distance


boardDistance : Board -> Int -> Int
boardDistance board dimension =
    let
        go coord acc =
            let
                tile =
                    case get coord board of
                        Nothing ->
                            0

                        Just value ->
                            value

                distance =
                    manhattan coord tile dimension
            in
                acc + distance
    in
        (coords dimension)
            |> List.foldr go 0


dfs : Board -> Int -> Int -> Int -> Direction -> Coord -> List Direction -> ( Bool, List Direction )
dfs board dimension depth maxDepth preDirection holeCoord directions =
    let
        h =
            boardDistance board dimension

        f =
            depth + h

        possibleDirections =
            adjacentTo dimension holeCoord
                |> List.map (possibleDirection holeCoord)
                |> List.filter (\direction -> direction /= opposite preDirection)

        checkNeighbor direction ( isDfsFinished, finalDirections ) =
            let
                newBoard =
                    slideTo dimension direction board

                newHoleCoord =
                    shift holeCoord direction
            in
                dfs newBoard dimension (depth + 1) maxDepth preDirection newHoleCoord (finalDirections ++ [ direction ])
    in
        if (f > maxDepth) then
            ( False, [] )
        else if (h == 0) then
            ( True, directions )
        else
            possibleDirections
                |> List.foldl checkNeighbor ( False, [] )


updateModel : Model -> Direction -> UpdateDirectionCategory -> Model
updateModel model direction category =
    let
        newBoard =
            model.board |> slideTo model.dimension direction

        newHoleCoord =
            shift model.holeCoord (opposite direction)

        tile =
            case get newHoleCoord model.board of
                Just value ->
                    value

                Nothing ->
                    0

        newDistance =
            --model.distance - (manhattan model.holeCoord tile model.dimension) + (manhattan newHoleCoord tile model.dimension)
            boardDistance newBoard model.dimension

        newDirections =
            case category of
                PushDirection ->
                    direction :: model.directions

                PopDirection ->
                    Maybe.withDefault [] (List.tail model.directions)
    in
        if newBoard == model.board then
            model
        else
            ({ model
                | board = newBoard
                , status = verify newBoard model.dimension model.status
                , holeCoord = newHoleCoord
                , distance = newDistance
                , moves = model.moves + 1
                , directions = newDirections
             }
            )


makeMove : Model -> Direction -> Maybe Model
makeMove model direction =
    case
        direction
            |> opposite
            |> shift model.holeCoord
            |> withinBoard model.dimension
    of
        True ->
            Just
                (updateModel model direction PushDirection)

        False ->
            Nothing


generatePossibleStates : Model -> List Model
generatePossibleStates model =
    allDirections
        |> List.filterMap (makeMove model)


search :
    Int
    -> Set (List ( ( Row, Column ), Tile ))
    -> Model
    -> ( Maybe Model, Set (List ( ( Row, Column ), Tile )), Bool )
search depthLimit visited model =
    let
        validStates s =
            not (Set.member (toList s.board) visited)
                && (s.distance + s.moves <= depthLimit)

        possibleStates =
            List.filter validStates (generatePossibleStates model)

        updatedVisited =
            possibleStates
                |> List.foldl
                    (\possibleState acc ->
                        Set.insert (toList possibleState.board) acc
                    )
                    visited
    in
        if isFinished model.board model.dimension then
            ( Just model, updatedVisited, True )
        else
            case possibleStates of
                [] ->
                    ( Nothing, updatedVisited, False )

                _ ->
                    possibleStates
                        |> List.foldl
                            (\possibleState ( accResult, accVisited, accIsFount ) ->
                                let
                                    ( newResult, newVisited, isFound ) =
                                        search
                                            depthLimit
                                            accVisited
                                            possibleState
                                in
                                    if accResult == Nothing && newResult == Nothing then
                                        ( Nothing, newVisited, False )
                                    else if newResult /= Nothing then
                                        ( newResult, newVisited, True )
                                    else
                                        ( accResult, newVisited, True )
                            )
                            ( Nothing, updatedVisited, False )


findSolution : Model -> Int -> Int -> Set (List ( ( Row, Column ), Tile )) -> Task.Task String (List Direction)
findSolution model depthLimit maxDepth visited =
    let
        solution =
            search depthLimit visited model

        newDepthLimit =
            depthLimit + 1
    in
        case solution of
            ( Just finalState, newVisited, _ ) ->
                Debug.log ("found")
                    Debug.log
                    (toString (Set.size newVisited))
                    Debug.log
                    (toString (newVisited))
                    Task.succeed
                    finalState.directions

            ( Nothing, newVisited, _ ) ->
                if newDepthLimit <= maxDepth then
                    Debug.log
                        (toString (newDepthLimit))
                        findSolution
                        model
                        newDepthLimit
                        maxDepth
                        visited
                else
                    Debug.log ("Not Found")
                        Task.fail
                        "Solution Not Found"
