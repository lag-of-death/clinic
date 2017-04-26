module People.Http exposing (..)

import Http
import Json.Decode as Decode
import People.Types exposing (..)


type alias Doc =
    { name : String
    , surname : String
    , email : String
    , id : Int
    , speciality : String
    }


getPeople : String -> Cmd Msg
getPeople whatPeople =
    Http.send PeopleData (Http.get ("/api/" ++ whatPeople) decodePeople)


getPatients : Cmd Msg
getPatients =
    getPeople "patients"


getDoctors : Cmd Msg
getDoctors =
    Http.send DoctorsData (Http.get ("/api/doctors") decodeDoctors)


decodePeople : Decode.Decoder (List Person)
decodePeople =
    Decode.list
        (Decode.map4 Person
            (Decode.field "name" Decode.string)
            (Decode.field "surname" Decode.string)
            (Decode.field "email" Decode.string)
            (Decode.field "id" Decode.int)
        )


decodeDoctors : Decode.Decoder (List (Doctor Person))
decodeDoctors =
    Decode.list
        (Decode.map5 Doc
            (Decode.field "name" Decode.string)
            (Decode.field "surname" Decode.string)
            (Decode.field "email" Decode.string)
            (Decode.field "id" Decode.int)
            (Decode.field "speciality" Decode.string)
        )


deleteDoctor : Int -> Cmd Msg
deleteDoctor id =
    Http.send DoctorDeleted
        (delete "doctors" id)


deletePerson : String -> Int -> Cmd Msg
deletePerson whatPeople id =
    Http.send PersonDeleted
        (delete whatPeople id)


delete : String -> a -> Http.Request ()
delete whatPeople id =
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
