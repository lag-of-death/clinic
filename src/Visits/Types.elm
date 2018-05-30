module Visits.Types
    exposing
        ( Visit
        , VisitsMsg(NewVisitsUrl, DelVisit, VisitsData, VisitData, VisitDeleted, NoVisitsOp, ReallyDelVisit)
        , defaultVisit
        , initialVisits
        , NewVisitMsg(..)
        , VisitsModel
        , NewVisitModel
        , initialNewVisit
        , NewVisitResult
        )

import Http
import People.Types as PT


defaultVisit : Visit
defaultVisit =
    { id = 0, date = 0, doctor = PT.defaultDoctor, nurse = PT.defaultNurse, patient = PT.defaultPatient, room = 0 }


initialVisits : List Visit
initialVisits =
    []


type alias NewVisitModel =
    { patientID : String
    , doctorID : String
    , nurseID : String
    , room : String
    , date : String
    }


initialNewVisit : NewVisitModel
initialNewVisit =
    { patientID = "0"
    , doctorID = "0"
    , nurseID = "0"
    , room = "0"
    , date = "0"
    }


type alias VisitsModel =
    List Visit


type alias NewVisitResult =
    String


type NewVisitMsg
    = NoNewVisitOp
    | SetPatient String
    | SetDoctor String
    | SetNurse String
    | SetDate String
    | SetRoom String
    | SendNewVisit
    | NewVisitData (Result Http.Error NewVisitResult)


type VisitsMsg
    = DelVisit Int
    | VisitsData (Result Http.Error (List Visit))
    | VisitData (Result Http.Error Visit)
    | VisitDeleted (Result Http.Error ())
    | NewVisitsUrl String
    | NoVisitsOp
    | ReallyDelVisit Int


type alias Visit =
    { patient : PT.Patient
    , doctor : PT.Doctor
    , nurse : PT.Nurse
    , date : Int
    , room : Int
    , id : Int
    }
