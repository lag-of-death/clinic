module Modal.Update exposing (Msg(Show, Hide, Do, Prepare, PrepareErr), update)

import Task
import Modal.Types exposing (Modal)


type Msg msg
    = Show
    | Hide
    | Do msg
    | Prepare msg
    | PrepareErr


update : Msg a -> Modal a -> a -> ( Modal a, Cmd a )
update modalMsg model noOp =
    case modalMsg of
        Show ->
            ( { model | shouldShow = True }, Cmd.none )

        Hide ->
            ( { model | shouldShow = False }, Cmd.none )

        Prepare msg ->
            ( { model
                | msg = msg
                , textMsg = "Are you sure?"
                , withActions = True
                , shouldShow = True
              }
            , Cmd.none
            )

        PrepareErr ->
            ( { model
                | msg = noOp
                , textMsg = "ERROR"
                , shouldShow = True
                , withActions = False
              }
            , Cmd.none
            )

        Do msg ->
            ( { model | shouldShow = False, msg = noOp }
            , Task.succeed msg |> Task.perform identity
            )
