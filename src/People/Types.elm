module People.Types exposing (..)

import Http


type alias Model =
    List Person


type alias Doctor a =
    { a | speciality : String }


type alias Person =
    { name : String
    , surname : String
    , email : String
    , id : Int
    }


type Msg
    = NewUrl String
    | PeopleData (Result Http.Error (List Person))
    | DelPerson Int
    | PersonDeleted (Result Http.Error ())
    | DoctorsData (Result Http.Error (List (Doctor Person)))
    | DoctorDeleted (Result Http.Error ())
