module Modal.Update exposing (..)

import Task exposing (..)


type Msg msg
    = Show
    | Hide
    | Do msg
    | Prepare msg


update :
    Msg a
    -> { c | msg : a, shouldShow : b }
    -> a
    -> ( { c | msg : a, shouldShow : Bool }, Cmd a )
update modalMsg model noOp =
    case modalMsg of
        Show ->
            ( { model | shouldShow = True }, Cmd.none )

        Hide ->
            ( { model | shouldShow = False }, Cmd.none )

        Prepare msg ->
            ( { model | msg = msg, shouldShow = True }
            , Cmd.none
            )

        Do msg ->
            ( { model | shouldShow = False, msg = noOp }
            , Task.succeed (msg) |> Task.perform identity
            )
