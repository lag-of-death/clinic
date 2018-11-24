module Requests exposing (delete)

import Http


delete : String -> Int -> Http.Request ()
delete entity id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "/api/" ++ entity ++ "/" ++ String.fromInt id
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = False
        }
