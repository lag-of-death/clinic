module People.Requests exposing (get, del)

import Http
import Json.Decode
import Requests exposing (delete)


get : String -> Json.Decode.Decoder a -> (Result Http.Error a -> msg) -> Cmd msg
get endpoint decoder msg =
    Http.send msg (Http.get ("/api/" ++ endpoint) decoder)


del : a -> (Result Http.Error () -> msg) -> String -> Cmd msg
del id msg enities =
    Http.send msg
        (delete enities id)
