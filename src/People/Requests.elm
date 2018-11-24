module People.Requests exposing (del, get)

import Http
import Json.Decode
import Requests exposing (delete)


get : String -> Json.Decode.Decoder a -> (Result Http.Error a -> msg) -> Cmd msg
get endpoint decoder msg =
    Http.send msg (Http.get ("/api/" ++ endpoint) decoder)


del : Int -> (Result Http.Error () -> msg) -> String -> Cmd msg
del id msg enities =
    Http.send msg
        (delete enities id)
