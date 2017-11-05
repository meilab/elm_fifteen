module Messages exposing (..)

import Types exposing (Board, Coord, Tile, Direction, UpdateDirectionCategory)
import Keyboard exposing (KeyCode)


type Msg
    = BoardGenerated Board
    | TileClicked Tile Coord
    | DirectionMove Direction UpdateDirectionCategory
    | OtherKeyPressed KeyCode
    | ChangeDimension String
    | Replay
    | Undo
    | Resolve
    | SolutionFound (Result String (List Direction))
    | PlaySolverResult
