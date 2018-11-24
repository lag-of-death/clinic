module Visits.Requests exposing (deleteVisit, getVisit, getVisits, newVisit)

import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Requests exposing (delete)
import Visits.Decoders exposing (decodeVisit, decodeVisits)
import Visits.Types as VT


deleteVisit : Int -> Cmd VT.VisitsMsg
deleteVisit id =
    Http.send VT.VisitDeleted
        (delete "visits" id)


getVisit : Int -> Cmd VT.VisitsMsg
getVisit id =
    Http.send VT.VisitData (Http.get ("/api/visits/" ++ String.fromInt id) decodeVisit)


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
                , ( "month", Encode.string model.month )
                , ( "day", Encode.string model.day )
                , ( "hour", Encode.string model.hour )
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
