module People.Helpers exposing (..)

import People.Types exposing (..)


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
    }


defaultDoctor : Doctor
defaultDoctor =
    { personalData = defaultPerson
    , speciality = "surgeon"
    }


defaultNurse : Nurse
defaultNurse =
    { personalData = defaultPerson
    , isDistrictNurse = False
    }


getPerson id people default =
    List.filter (\person -> person.personalData.id == id) people
        |> List.head
        |> Maybe.withDefault default
