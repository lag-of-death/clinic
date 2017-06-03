module People.Types exposing (..)

import Http


defaultPerson : Person
defaultPerson =
    { name = ""
    , surname = ""
    , email = ""
    , id = -9999
    }


defaultPatient : Patient
defaultPatient =
    { personalData = defaultPerson
    , id = 0
    }


defaultDoctor : Doctor
defaultDoctor =
    { personalData = defaultPerson
    , speciality = "surgeon"
    , id = 0
    }


defaultNurse : Nurse
defaultNurse =
    { personalData = defaultPerson
    , isDistrictNurse = False
    , id = 0
    }


initialNurses : List Nurse
initialNurses =
    []


initialDoctors : List Doctor
initialDoctors =
    []


initialPatients : List Patient
initialPatients =
    []


type alias DoctorsModel =
    List Doctor


type alias NursesModel =
    List Nurse


type alias PatientsModel =
    List Patient


type alias Patient =
    { personalData : Person
    , id : Int
    }


type alias Doctor =
    { personalData : Person, speciality : String, id : Int }


type alias Nurse =
    { personalData : Person, isDistrictNurse : Bool, id : Int }


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
