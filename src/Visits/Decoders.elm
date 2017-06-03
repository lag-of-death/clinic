module Visits.Decoders exposing (..)

import Json.Decode as Decode
import People.Decoders exposing (..)
import Visits.Types exposing (..)


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
