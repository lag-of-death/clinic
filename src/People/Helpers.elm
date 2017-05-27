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


getPerson : a -> List { b | id : a } -> { b | id : a } -> { b | id : a }
getPerson id people default =
    List.filter (\person -> person.id == id) people
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
