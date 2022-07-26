module Utils.Func exposing (..)

import Task


run : msg -> Cmd msg
run m =
    Task.perform (always m) (Task.succeed ())
