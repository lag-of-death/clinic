module Modal.Types exposing (..)


initialModel : a -> { msg : a, shouldShow : Bool, textMsg : String }
initialModel msg =
    { shouldShow = False
    , textMsg = "Are you sure?"
    , msg = msg
    }


type alias Modal msg =
    { shouldShow : Bool
    , textMsg : String
    , msg : msg
    }
