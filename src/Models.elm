module Models exposing (..)

import Types exposing (Model, Coord, Board, GameStatus(..))
import Board exposing (makeBoard, orderedTiles, emptyBoard)


initModel : Int -> Model
initModel dimension =
    { board = (makeBoard dimension) (orderedTiles dimension)
    , status = Playing
    , dimension = dimension
    , holeCoord = ( dimension, dimension )
    , distance = 0
    , moves = 0
    , directions = []
    }
