module Modal.Update exposing (Msg(..), update)

import Modal.Types exposing (Modal)
import Task


type Msg msg
    = Show
    | Hide
    | Do msg
    | Prepare msg
    | PrepareErr msg
    | ShowMsg String msg


update modalMsg model noOp locals =
    case modalMsg of
        Show ->
            ( { model | shouldShow = True, showCloseBtn = True }, Cmd.none )

        Hide ->
            ( { model | shouldShow = False, showCloseBtn = True }, Cmd.none )

        Prepare msg ->
            ( { model
                | msg = msg
                , textMsg = locals.areYouSure
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
                , textMsg = locals.error
                , shouldShow = True
                , showCloseBtn = False
              }
            , Cmd.none
            )

        Do msg ->
            ( { model | shouldShow = False, msg = noOp, showCloseBtn = True }
            , Task.succeed msg |> Task.perform identity
            )
