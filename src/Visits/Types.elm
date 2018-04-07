module Visits.Types
    exposing
        ( Visit
        , VisitsMsg(NewVisitsUrl, DelVisit, VisitsData, VisitData, VisitDeleted, NoVisitsOp, ReallyDelVisit)
        , defaultVisit
        , initialVisits
        , VisitsModel
        )

import Http
import People.Types as PT


defaultVisit : Visit
defaultVisit =
    { id = 0, date = 0, doctor = PT.defaultDoctor, nurse = PT.defaultNurse, patient = PT.defaultPatient }


initialVisits : List Visit
initialVisits =
    []


type alias VisitsModel =
    List Visit


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
    , id : Int
    }
