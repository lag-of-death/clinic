module Requests exposing (..)

import Http exposing (..)


delete : String -> a -> Http.Request ()
delete entity id =
    (Http.request
        { method = "DELETE"
        , headers = []
        , url = "/api/" ++ entity ++ "/" ++ (toString id)
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = False
        }
    )
