module Models exposing (..)

import Types exposing (Model, Coord, Board, GameStatus(..))
import Board exposing (makeBoard, orderedTiles, emptyBoard)


initBoard : Int -> Board
initBoard dimension =
    (makeBoard dimension) (orderedTiles dimension)


initModel : Int -> Board -> Model
initModel dimension board =
    { board = board
    , status = Playing
    , dimension = dimension
    , holeCoord = ( dimension, dimension )
    , distance = 0
    , moves = 0
    , directions = []
    }
