module Modal.Types exposing (initialModel, Modal)


initialModel : a -> { msg : a, shouldShow : Bool, textMsg : String, showCloseBtn : Bool }
initialModel msg =
    { shouldShow = False
    , textMsg = "Are you sure?"
    , msg = msg
    , showCloseBtn = True
    }


type alias Modal msg =
    { shouldShow : Bool
    , textMsg : String
    , msg : msg
    , showCloseBtn : Bool
    }
