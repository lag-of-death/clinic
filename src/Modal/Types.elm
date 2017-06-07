module Modal.Types exposing (..)


initialModel : a -> { msg : a, shouldShow : Bool, textMsg : String, withActions : Bool }
initialModel msg =
    { shouldShow = False
    , textMsg = "Are you sure?"
    , msg = msg
    , withActions = True
    }


type alias Modal msg =
    { shouldShow : Bool
    , textMsg : String
    , msg : msg
    , withActions : Bool
    }
