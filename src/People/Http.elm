module People.Http exposing (..)

import Http
import Json.Decode as Decode
import People.Types exposing (..)


getPatients : Cmd Msg
getPatients =
    Http.send PatientsData (Http.get "/api/patients" decodePatients)


getDoctors : Cmd Msg
getDoctors =
    Http.send DoctorsData (Http.get ("/api/doctors") decodeDoctors)


getNurses : Cmd Msg
getNurses =
    Http.send NursesData (Http.get ("/api/nurses") decodeNurses)


decodePerson =
    Decode.map4 Person
        (Decode.field "name" Decode.string)
        (Decode.field "surname" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "id" Decode.int)


decodePatient =
    Decode.map Patient (Decode.field "personalData" decodePerson)


decodePatients =
    Decode.list decodePatient


decodePeople : Decode.Decoder (List Person)
decodePeople =
    Decode.list decodePerson


decodeDoctor =
    Decode.map2 Doctor
        (Decode.field "personalData" decodePerson)
        (Decode.field "speciality" Decode.string)


decodeDoctors : Decode.Decoder (List Doctor)
decodeDoctors =
    Decode.list decodeDoctor


decodeNurses : Decode.Decoder (List Nurse)
decodeNurses =
    Decode.list
        (Decode.map2 Nurse
            (Decode.field "personalData" decodePerson)
            (Decode.field "isDistrictNurse" Decode.bool)
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
