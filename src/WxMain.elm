port module WxMain exposing (..)

import Models exposing (..)
import Messages exposing (Msg(..))
import WxUpdate exposing (..)
import Platform
import Json.Decode


port messagesIn : (( String, String ) -> msg) -> Sub msg


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        parse value =
            case value of
                ( "PhraseInput", phrase ) ->
                    PhraseInput phrase

                ( "ServiceInput", service ) ->
                    ServiceInput service

                ( "PwLengthInput", pwLength ) ->
                    PwLengthInput (Result.withDefault 6 (String.toInt pwLength))

                _ ->
                    NoOp
    in
        messagesIn parse


main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
