module Visits.Types exposing (..)

import Http exposing (..)
import People.Types exposing (..)
import People.Helpers exposing (..)


defaultVisit : Visit
defaultVisit =
    { id = 0, date = "", doctors = [], nurses = [], patient = defaultPatient }


initialNewVisit : NewVisitModel
initialNewVisit =
    { numOfDoctors = 1
    , numOfNurses = 1
    }


initialVisits : List Visit
initialVisits =
    []


type alias VisitsModel =
    List Visit


type NewVisitMsg
    = IncDoctors
    | IncNurses
    | DecDoctors
    | DecNurses
    | NoNewVisitOp


type VisitsMsg
    = DelVisit Int
    | VisitsData (Result Http.Error (List Visit))
    | VisitData (Result Http.Error Visit)
    | VisitDeleted (Result Http.Error ())
    | NewVisitsUrl String
    | NoVisitsOp
    | ReallyDelVisit Int


type alias NewVisitModel =
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
