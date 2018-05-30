module Visits.Requests exposing (getVisits, deleteVisit, getVisit, newVisit)

import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Visits.Types as VT
import Visits.Decoders exposing (decodeVisit, decodeVisits)
import Http exposing (..)
import Requests exposing (delete)


deleteVisit : Int -> Cmd VT.VisitsMsg
deleteVisit id =
    Http.send VT.VisitDeleted
        (delete "visits" id)


getVisit : Int -> Cmd VT.VisitsMsg
getVisit id =
    Http.send VT.VisitData (Http.get ("/api/visits/" ++ toString id) decodeVisit)


newVisit : VT.NewVisitModel -> Cmd VT.NewVisitMsg
newVisit model =
    let
        encoder =
            Encode.object
                [ ( "room", Encode.string model.room )
                , ( "patientID", Encode.string model.patientID )
                , ( "doctorID", Encode.string model.doctorID )
                , ( "nurseID", Encode.string model.nurseID )
                , ( "date", Encode.string model.date )
                ]
    in
        Http.send VT.NewVisitData
            (Http.post "/api/visits/"
                (jsonBody encoder)
                Decode.string
            )


getVisits : Cmd VT.VisitsMsg
getVisits =
    Http.send VT.VisitsData (Http.get "/api/visits" decodeVisits)
