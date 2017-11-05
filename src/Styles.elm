module Styles exposing (..)


type alias Styles =
    List ( String, String )


container : Int -> Styles
container dimension =
    [ ( "display", "flex " )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    , ( "width", (toString (dimension * 98 + 40)) ++ "px" )
    , ( "background-color", "#222" )

    --, ( "height", (toString (dimension * 98 + 40)) ++ "px" )
    --, ( "height", "100vh" )
    ]


board : Int -> Styles
board dimension =
    [ ( "height", (toString (dimension * 98 + 40)) ++ "px" )
    ]


row : Int -> Styles
row dimension =
    [ ( "display", "flex " )
    , ( "justify-content", "space-around" )
    , ( "width", (toString (dimension * 98 + 40)) ++ "px" )
    ]


controller : Int -> Styles
controller dimension =
    [ ( "display", "flex " )
    , ( "justify-content", "space-around" )
    , ( "width", (toString (dimension * 98 + 40)) ++ "px" )
    ]


victoryOverlay : Styles
victoryOverlay =
    [ ( "position", "absolute" )
    , ( "z-index", "999" )
    , ( "background-color", "rgba(255,255,255,0.95)" )
    , ( "top", "0" )
    , ( "bottom", "0" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    ]


victoryTitle : Styles
victoryTitle =
    [ ( "font-size", "10vh" )
    , ( "margin", "0" )
    ]


replayButton : Styles
replayButton =
    [ ( "font-size", "20px" )
    , ( "margin", "0" )
    , ( "padding", "10px" )
    ]


lineBreak : Styles
lineBreak =
    [ ( "clear", "both" ) ]
