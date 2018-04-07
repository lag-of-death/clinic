module Visits.Decoders exposing (decodeVisit, decodeVisits)

import Json.Decode as Decode
import People.Decoders as PD
import Visits.Types exposing (Visit)


decodeVisit : Decode.Decoder Visit
decodeVisit =
    Decode.map5 Visit
        (Decode.field "patient" PD.decodePatient)
        (Decode.field "doctor" PD.decodeDoctor)
        (Decode.field "nurse" PD.decodeNurse)
        (Decode.field "date" Decode.int)
        (Decode.field "id" Decode.int)


decodeVisits : Decode.Decoder (List Visit)
decodeVisits =
    Decode.list decodeVisit
