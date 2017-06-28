module Visits.Types
    exposing
        ( Visit
        , NewVisitMsg
            ( IncNurses
            , IncDoctors
            , DecDoctors
            , DecNurses
            , NoNewVisitOp
            )
        , VisitsMsg(NewVisitsUrl, DelVisit, VisitsData, VisitData, VisitDeleted, NoVisitsOp, ReallyDelVisit)
        , defaultVisit
        , initialVisits
        , initialNewVisit
        , VisitsModel
        , NewVisitModel
        )

import Http
import People.Types as PT


defaultVisit : Visit
defaultVisit =
    { id = 0, date = "", doctors = [], nurses = [], patient = PT.defaultPatient }


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
    { patient : PT.Patient
    , doctors : List PT.Doctor
    , nurses : List PT.Nurse
    , date : String
    , id : Int
    }
