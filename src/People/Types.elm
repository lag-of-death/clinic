module People.Types
    exposing
        ( Person
        , Nurse
        , Doctor
        , Patient
        , defaultPerson
        , defaultNurse
        , defaultPatient
        , initialNurses
        , initialPatients
        , initialDoctors
        , defaultDoctor
        , PatientsModel
        , StaffModel
        , StaffMember
        , DoctorsModel
        , NursesModel
        , NursesMsg
            ( DelNurse
            , NursesData
            , NurseData
            , NurseDeleted
            , NewNursesUrl
            , NoNursesOp
            , ReallyDeleteNurse
            )
        , DoctorsMsg
            ( NewDoctorsUrl
            , DelDoctor
            , DoctorsData
            , DoctorData
            , DoctorDeleted
            , NoDoctorsOp
            , ReallyDeleteDoctor
            )
        , PatientsMsg
            ( NewPatientsUrl
            , PatientsData
            , PatientData
            , DelPatient
            , ReallyDeletePatient
            , PatientDeleted
            , NoPatientsOp
            )
        )

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
    { personal = defaultPerson
    , id = 0
    }


defaultDoctor : Doctor
defaultDoctor =
    { personal = defaultPerson
    , speciality = "surgeon"
    , id = 0
    }


defaultNurse : Nurse
defaultNurse =
    { personal = defaultPerson
    , district = False
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


type alias StaffModel =
    List StaffMember


type alias StaffMember =
    { personal : Person
    , id : Int
    , who : String
    }


type alias Patient =
    { personal : Person
    , id : Int
    }


type alias Doctor =
    { personal : Person
    , speciality : String
    , id : Int
    }


type alias Nurse =
    { personal : Person
    , district : Bool
    , id : Int
    }


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
    | NoNursesOp
    | ReallyDeleteNurse Int


type DoctorsMsg
    = NewDoctorsUrl String
    | DelDoctor Int
    | DoctorsData (Result Http.Error (List Doctor))
    | DoctorData (Result Http.Error Doctor)
    | DoctorDeleted (Result Http.Error ())
    | NoDoctorsOp
    | ReallyDeleteDoctor Int


type PatientsMsg
    = NewPatientsUrl String
    | PatientsData (Result Http.Error (List Patient))
    | PatientData (Result Http.Error Patient)
    | DelPatient Int
    | ReallyDeletePatient Int
    | PatientDeleted (Result Http.Error ())
    | NoPatientsOp
