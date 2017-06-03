module Visits.Requests exposing (..)

import Visits.Types exposing (..)
import Visits.Decoders exposing (..)
import Http exposing (..)
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
