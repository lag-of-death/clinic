module Patients.Helpers exposing (getPatient)

import Patients.Types exposing (Patient)


getPatient : Int -> List Patient -> Patient
getPatient id patients =
    let
        defaultPatient =
            { name = "Jan Kowalski"
            , id = -9999
            }
    in
        List.filter (\patient -> patient.id == id) patients
            |> List.head
            |> Maybe.withDefault defaultPatient
