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


getPerson : Int -> List { a | personalData : { b | id : Int } } -> { a | personalData : { b | id : Int } } -> { a | personalData : { b | id : Int } }
getPerson id people default =
    List.filter (\person -> person.personalData.id == id) people
        |> List.head
        |> Maybe.withDefault default


addPerson : List { a | personalData : { b | id : Int } } -> { a | personalData : { b | id : Int } } -> List { a | personalData : { b | id : Int } }
addPerson model entity =
    if List.isEmpty model then
        [ entity ]
    else
        List.map
            (\oldEntity ->
                if oldEntity.personalData.id == entity.personalData.id then
                    entity
                else
                    oldEntity
            )
            model
