module People.Types exposing (..)

import Http


type alias Model =
    List Patient


type alias Patient =
    { personalData : Person
    }


type alias Doctor =
    { personalData : Person, speciality : String }


type alias Nurse =
    { personalData : Person, isDistrictNurse : Bool }


type alias Person =
    { name : String
    , surname : String
    , email : String
    , id : Int
    }


type NursesMsg
    = DelNurse Int
    | NursesData (Result Http.Error (List Nurse))
    | NurseData (Result Http.Error Nurse)
    | NurseDeleted (Result Http.Error ())
    | NewNursesUrl String


type DoctorsMsg
    = NewDoctorsUrl String
    | DelDoctor Int
    | DoctorsData (Result Http.Error (List Doctor))
    | DoctorData (Result Http.Error Doctor)
    | DoctorDeleted (Result Http.Error ())


type PatientsMsg
    = NewPatientsUrl String
    | PatientsData (Result Http.Error (List Patient))
    | PatientData (Result Http.Error Patient)
    | DelPatient Int
    | PatientDeleted (Result Http.Error ())
