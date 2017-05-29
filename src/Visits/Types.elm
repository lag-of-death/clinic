module Visits.Types exposing (..)

import Http exposing (..)
import People.Types exposing (..)
import People.Helpers exposing (..)


newVisit : NewVisit
newVisit =
    { numOfDoctors = 1
    , numOfNurses = 1
    }


type NewVisitMsg
    = IncDoctors
    | IncNurses
    | DecDoctors
    | DecNurses


type VisitsMsg
    = DelVisit Int
    | VisitsData (Result Http.Error (List Visit))
    | VisitData (Result Http.Error Visit)
    | VisitDeleted (Result Http.Error ())
    | NewVisitsUrl String


type alias NewVisit =
    { numOfDoctors : Int
    , numOfNurses : Int
    }


type alias Visit =
    { patient : Patient
    , doctors : List Doctor
    , nurses : List Nurse
    , date : String
    , id : Int
    }
