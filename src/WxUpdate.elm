port module WxUpdate exposing (..)

import Models exposing (..)
import Messages exposing (Msg(..))
import Password exposing (..)


port modelOut : String -> Cmd msg


generatePassword : Model -> String
generatePassword model =
    case (model.phrase == "" || model.service == "") of
        True ->
            ""

        _ ->
            doGeneratePassword model.phrase model.service model.pwLength model.pwCategory


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, newCmd ) =
            case msg of
                PhraseInput phrase ->
                    let
                        password =
                            generatePassword { model | phrase = phrase }

                        newModel =
                            { model | phrase = phrase, password = password }
                    in
                        ( newModel, Cmd.none )

                ServiceInput service ->
                    let
                        password =
                            generatePassword { model | service = service }

                        newModel =
                            { model | service = service, password = password }
                    in
                        ( newModel, Cmd.none )

                PwLengthInput pwLength ->
                    let
                        password =
                            generatePassword { model | pwLength = pwLength }

                        newModel =
                            { model | pwLength = pwLength, password = password }
                    in
                        ( newModel, Cmd.none )

                NoOp ->
                    ( model, Cmd.none )
    in
        ( newModel
        , Cmd.batch
            ([ newCmd
             , modelOut newModel.password
             ]
            )
        )
