module Modal.Types exposing (initialModel, Modal)


initialModel areYouSure msg =
    { shouldShow = False
    , textMsg = areYouSure
    , msg = msg
    , showCloseBtn = True
    }


type alias Modal msg =
    { shouldShow : Bool
    , textMsg : String
    , msg : msg
    , showCloseBtn : Bool
    }
