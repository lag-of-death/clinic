module People.Helpers exposing (..)

import People.Types exposing (Person, Doctor)


defaultPerson : Person
defaultPerson =
    { name = "Jan"
    , surname = "Kowalski"
    , email = "abc@xyz.pl"
    , id = -9999
    }


defaultDoctor : Doctor Person
defaultDoctor =
    { name = "Jan"
    , surname = "Kowalski"
    , email = "abc@xyz.pl"
    , id = -9999
    , speciality = "surgeon"
    }


getPerson : a -> List { b | id : a } -> { b | id : a } -> { b | id : a }
getPerson id people default =
    List.filter (\person -> person.id == id) people
        |> List.head
        |> Maybe.withDefault default
