module People.Http exposing (..)

import Http
import Json.Decode as Decode
import People.Types exposing (..)


getPeople : String -> Cmd Msg
getPeople whatPeople =
    Http.send PeopleData (Http.get ("/api/" ++ whatPeople) decodePeople)


decodePeople : Decode.Decoder (List Person)
decodePeople =
    Decode.list
        (Decode.map4 Person
            (Decode.field "name" Decode.string)
            (Decode.field "surname" Decode.string)
            (Decode.field "email" Decode.string)
            (Decode.field "id" Decode.int)
        )


deletePerson : String -> Int -> Cmd Msg
deletePerson whatPeople id =
    Http.send PersonDeleted
        (Http.request
            { method = "DELETE"
            , headers = []
            , url = "/api/" ++ whatPeople ++ "/" ++ (toString id)
            , body = Http.emptyBody
            , expect = Http.expectStringResponse (\_ -> Ok ())
            , timeout = Nothing
            , withCredentials = False
            }
        )
