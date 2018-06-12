module Modal.Update exposing (Msg(Show, Hide, Do, Prepare, ShowMsg, PrepareErr), update)

import Task
import Modal.Types exposing (Modal)


type Msg msg
    = Show
    | Hide
    | Do msg
    | Prepare msg
    | PrepareErr msg
    | ShowMsg String msg


update : Msg a -> Modal a -> a -> ( Modal a, Cmd a )
update modalMsg model noOp =
    case modalMsg of
        Show ->
            ( { model | shouldShow = True, showCloseBtn = True }, Cmd.none )

        Hide ->
            ( { model | shouldShow = False, showCloseBtn = True }, Cmd.none )

        Prepare msg ->
            ( { model
                | msg = msg
                , textMsg = "Are you sure?"
                , shouldShow = True
                , showCloseBtn = True
              }
            , Cmd.none
            )

        ShowMsg text msg ->
            ( { model
                | msg = msg
                , textMsg = text
                , shouldShow = True
                , showCloseBtn = False
              }
            , Cmd.none
            )

        PrepareErr msg ->
            ( { model
                | msg = msg
                , textMsg = "ERROR"
                , shouldShow = True
                , showCloseBtn = False
              }
            , Cmd.none
            )

        Do msg ->
            ( { model | shouldShow = False, msg = noOp, showCloseBtn = True }
            , Task.succeed msg |> Task.perform identity
            )
