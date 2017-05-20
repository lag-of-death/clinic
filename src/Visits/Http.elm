module Visits.Http exposing (..)

import Visits.Types exposing (..)
import Http exposing (..)
import Json.Decode as Decode


getVisits : Cmd VisitsMsg
getVisits =
    Http.send VisitsData (Http.get "/api/visits" decodeVisits)


decodeVisits : Decode.Decoder (List Visit)
decodeVisits =
    Decode.list
        (Decode.map5 Visit
            (Decode.field "patient" Decode.int)
            (Decode.field "doctors" (Decode.list Decode.int))
            (Decode.field "nurses" (Decode.list Decode.int))
            (Decode.field "date" Decode.string)
            (Decode.field "id" Decode.int)
        )
