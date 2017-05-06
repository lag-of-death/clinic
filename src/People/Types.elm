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


type Msg
    = NewUrl String
    | PatientsData (Result Http.Error (List Patient))
    | DelPerson Int
    | PersonDeleted (Result Http.Error ())
    | DoctorsData (Result Http.Error (List Doctor))
    | NursesData (Result Http.Error (List Nurse))
    | NurseDeleted (Result Http.Error ())
    | DoctorDeleted (Result Http.Error ())
