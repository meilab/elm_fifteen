module Utils exposing (..)

import Task
import Process
import Time exposing (Time)


cmd : msg -> Cmd msg
cmd msg =
    Task.perform (always msg) (Task.succeed msg)


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
