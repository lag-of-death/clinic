module Modal.Types exposing (initialModel, Modal)


initialModel : a -> { msg : a, shouldShow : Bool, textMsg : String, withActions : Bool, showCloseBtn : Bool }
initialModel msg =
    { shouldShow = False
    , textMsg = "Are you sure?"
    , msg = msg
    , withActions = True
    , showCloseBtn = True
    }


type alias Modal msg =
    { shouldShow : Bool
    , textMsg : String
    , msg : msg
    , withActions : Bool
    , showCloseBtn : Bool
    }
