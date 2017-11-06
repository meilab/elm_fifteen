module Board
    exposing
        ( emptyBoard
        , makeBoard
        , orderedTiles
        , randomBoard
        , isSolvable
        , isFinished
        , findAdjacentHole
        , moveTile
        , findHole
        , slideTo
        , shift
        , opposite
        , withinBoard
        , allDirections
        , possibleDirection
        , adjacentTo
        , coords
        )

import Dict exposing (Dict, fromList, insert, get, remove, values)
import List exposing (concatMap, filter, length, map, map2, range, foldr, foldl)
import Random exposing (Generator)
import Random.List exposing (shuffle)
import Types exposing (..)


allDirections : List Direction
allDirections =
    [ Left, Up, Right, Down ]


emptyBoard : Board
emptyBoard =
    fromList []


randomBoard : Int -> Generator Board
randomBoard dimension =
    Random.map (makeBoard dimension) (shuffle (orderedTiles dimension))


makeBoard : Int -> List (Maybe Tile) -> Board
makeBoard dimension tiles =
    let
        fillBoard ( coord, tile ) board =
            case tile of
                Nothing ->
                    board

                Just x ->
                    insert coord x board
    in
        map2 (,) (coords dimension) tiles |> foldr fillBoard (fromList [])


orderedTiles : Int -> List (Maybe Tile)
orderedTiles dimension =
    map Just (range 1 (dimension ^ 2 - 1)) ++ [ Nothing ]


coords : Int -> List Coord
coords dimension =
    let
        rowCoords row =
            map (coord row) (range 1 dimension)

        coord row column =
            ( row, column )
    in
        concatMap rowCoords (range 1 dimension)


isSolvable : Board -> Int -> Bool
isSolvable board dimension =
    let
        inversions =
            countInversions (values board)

        countInversions tiles =
            case tiles of
                [] ->
                    0

                x :: ys ->
                    let
                        xInversions =
                            ys |> filter (\y -> x > y) |> length
                    in
                        xInversions + (countInversions ys)

        ( r, _ ) =
            findHole dimension board

        holeRow =
            dimension - r

        isEven number =
            number % 2 == 0

        isOdd =
            not << isEven
    in
        if isOdd dimension then
            isEven inversions
        else
            ((isOdd holeRow && isOdd inversions)
                || (isEven holeRow && isEven inversions)
            )


isFinished : Board -> Int -> Bool
isFinished board dimension =
    let
        totalTiles =
            dimension ^ 2 - 1

        bottomRightCoord =
            ( dimension, dimension )
    in
        if values board == (range 1 totalTiles) && get bottomRightCoord board == Nothing then
            True
        else
            False


shift : Coord -> Direction -> Coord
shift ( row, column ) direction =
    case direction of
        Left ->
            ( row, column - 1 )

        Up ->
            ( row - 1, column )

        Right ->
            ( row, column + 1 )

        Down ->
            ( row + 1, column )


adjacentTo : Int -> Coord -> List Coord
adjacentTo dimension coord =
    allDirections
        |> map (shift coord)
        |> filter (withinBoard dimension)


withinBoard : Int -> Coord -> Bool
withinBoard dimension ( row, column ) =
    if (row > 0) && (row <= dimension) && (column > 0) && (column <= dimension) then
        True
    else
        False


findAdjacentHole : Board -> Int -> Coord -> Maybe Coord
findAdjacentHole board dimension ( row, column ) =
    let
        findHoleCoord coord acc =
            case acc of
                Just _ ->
                    acc

                Nothing ->
                    case get coord board of
                        Nothing ->
                            Just coord

                        _ ->
                            Nothing
    in
        adjacentTo dimension ( row, column ) |> foldr findHoleCoord Nothing


findHole : Int -> Board -> Coord
findHole dimension board =
    let
        go coord acc =
            if get coord board == Nothing then
                coord
            else
                acc
    in
        (coords dimension) |> foldr go ( 1, 1 )


moveTile : Tile -> Coord -> Coord -> Board -> Board
moveTile tile tileCoord holeCoord board =
    board |> insert holeCoord tile |> remove tileCoord


slideTo : Int -> Direction -> Board -> Board
slideTo dimension direction board =
    let
        holeCoord =
            board |> (findHole dimension)

        tileCoord =
            shift holeCoord (opposite direction)

        possibleTile =
            board |> get tileCoord
    in
        case possibleTile of
            Just tile ->
                board |> moveTile tile tileCoord holeCoord

            Nothing ->
                board


possibleDirection : Coord -> Coord -> Direction
possibleDirection ( rowFrom, colFrom ) ( rowTo, colTo ) =
    if rowFrom < rowTo then
        Down
    else if rowFrom > rowTo then
        Up
    else if colFrom < colTo then
        Right
    else
        Left


opposite : Direction -> Direction
opposite direction =
    case direction of
        Left ->
            Right

        Up ->
            Down

        Right ->
            Left

        Down ->
            Up
