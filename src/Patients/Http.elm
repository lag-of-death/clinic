module Patients.Http exposing (..)

import Http
import Json.Decode as Decode
import Patients.Types exposing (..)


getPatients : Cmd Msg
getPatients =
    Http.send PatientsData (Http.get "/api/patients" decodePatients)


decodePatients : Decode.Decoder (List Patient)
decodePatients =
    Decode.list
        (Decode.map4 Patient
            (Decode.field "name" Decode.string)
            (Decode.field "surname" Decode.string)
            (Decode.field "email" Decode.string)
            (Decode.field "id" Decode.int)
        )
