module Visits.Requests exposing (..)

import Visits.Types exposing (..)
import Http exposing (..)
import Json.Decode as Decode
import Requests exposing (..)
import People.Requests exposing (..)


deleteVisit : Int -> Cmd VisitsMsg
deleteVisit id =
    Http.send VisitDeleted
        (delete "visits" id)


getVisits : Cmd VisitsMsg
getVisits =
    Http.send VisitsData (Http.get "/api/visits" decodeVisits)


decodeVisits : Decode.Decoder (List Visit)
decodeVisits =
    Decode.list
        (Decode.map5 Visit
            (Decode.field "patient" decodePatient)
            (Decode.field "doctors" decodeDoctors)
            (Decode.field "nurses" decodeNurses)
            (Decode.field "date" Decode.string)
            (Decode.field "id" Decode.int)
        )
