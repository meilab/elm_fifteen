module Types exposing (..)

import Dict exposing (Dict, fromList, insert, get, remove, values)


type alias Board =
    Dict Coord Tile


type alias Row =
    Int


type alias Column =
    Int


type alias Coord =
    ( Row, Column )


type alias Tile =
    Int


type Direction
    = Left
    | Right
    | Up
    | Down


type UpdateDirectionCategory
    = PushDirection
    | PopDirection


type GameStatus
    = Playing
    | Solving
    | ShowSolver
    | Finished


type alias Model =
    { board : Board
    , status : GameStatus
    , dimension : Int
    , holeCoord : Coord
    , distance : Int
    , moves : Int
    , directions : List Direction
    }
