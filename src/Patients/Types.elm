module Patients.Types exposing (..)

import Http


type alias Model =
    List Patient


type alias Patient =
    { name : String
    , id : Int
    }


type Msg
    = GetPatients
    | PatientsData (Result Http.Error (List Patient))
    | NewUrl String
