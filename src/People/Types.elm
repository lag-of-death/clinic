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
    | NurseDeleted (Result Http.Error ())
    | NewNursesUrl String


type DoctorsMsg
    = NewDoctorsUrl String
    | DelDoctor Int
    | DoctorsData (Result Http.Error (List Doctor))
    | DoctorDeleted (Result Http.Error ())


type PatientsMsg
    = NewPatientsUrl String
    | PatientsData (Result Http.Error (List Patient))
    | DelPatient Int
    | PatientDeleted (Result Http.Error ())
