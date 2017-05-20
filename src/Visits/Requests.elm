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


getVisit : Int -> Cmd VisitsMsg
getVisit id =
    Http.send VisitData (Http.get ("/api/visits/" ++ (toString id)) decodeVisit)


getVisits : Cmd VisitsMsg
getVisits =
    Http.send VisitsData (Http.get "/api/visits" decodeVisits)


decodeVisit : Decode.Decoder Visit
decodeVisit =
    (Decode.map5 Visit
        (Decode.field "patient" decodePatient)
        (Decode.field "doctors" decodeDoctors)
        (Decode.field "nurses" decodeNurses)
        (Decode.field "date" Decode.string)
        (Decode.field "id" Decode.int)
    )


decodeVisits : Decode.Decoder (List Visit)
decodeVisits =
    Decode.list decodeVisit
