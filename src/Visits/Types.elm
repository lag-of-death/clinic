module Visits.Types exposing (..)

import Http exposing (..)
import People.Types exposing (..)
import People.Helpers exposing (..)


type VisitsMsg
    = DelVisit Int
    | VisitsData (Result Http.Error (List Visit))
    | VisitDeleted (Result Http.Error ())
    | NewVisitsUrl String


type alias Visit =
    { patient : Patient
    , doctors : List Doctor
    , nurses : List Nurse
    , date : String
    , id : Int
    }
