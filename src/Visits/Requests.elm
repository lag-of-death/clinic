module Visits.Requests exposing (getVisits, deleteVisit, getVisit)

import Visits.Types as VT
import Visits.Decoders exposing (decodeVisit, decodeVisits)
import Http
import Requests exposing (delete)


deleteVisit : Int -> Cmd VT.VisitsMsg
deleteVisit id =
    Http.send VT.VisitDeleted
        (delete "visits" id)


getVisit : Int -> Cmd VT.VisitsMsg
getVisit id =
    Http.send VT.VisitData (Http.get ("/api/visits/" ++ toString id) decodeVisit)


getVisits : Cmd VT.VisitsMsg
getVisits =
    Http.send VT.VisitsData (Http.get "/api/visits" decodeVisits)
