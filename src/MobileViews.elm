module MobileViews exposing (view)

import NativeUi as Ui exposing (Node)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)
import Models exposing (..)
import Messages exposing (Msg(..))


view : Model -> Node Msg
view model =
    Elements.view
        [ Ui.style [ Style.alignItems "center" ]
        ]
        [ textInput
            [ Ui.style
                [ Style.textAlign "center"
                , Style.marginBottom 30
                ]
            ]
            []
        , textInput
            [ Ui.style
                [ Style.textAlign "center"
                , Style.marginBottom 30
                ]
            ]
            []
        , textInput
            [ Ui.style
                [ Style.textAlign "center"
                , Style.marginBottom 30
                ]
            ]
            []
        , Elements.view
            [ Ui.style
                [ Style.width 80
                , Style.flexDirection "row"
                , Style.justifyContent "space-between"
                ]
            ]
            [ text [] [ Ui.string model.password ]
            ]
        ]
