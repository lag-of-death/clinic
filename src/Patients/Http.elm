module Patients.Http exposing (..)

import Http
import Json.Decode as Decode
import Patients.Types exposing (..)


getPatients : Cmd Msg
getPatients =
    Http.send PatientsData (Http.get "/patients-data" decodePatients)


decodePatients : Decode.Decoder (List Patient)
decodePatients =
    Decode.list
        (Decode.map2 Patient
            (Decode.field "name" Decode.string)
            (Decode.field "id" Decode.int)
        )
