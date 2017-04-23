module People.Helpers exposing (getPerson)

import People.Types exposing (Person)


getPerson : Int -> List Person -> Person
getPerson id people =
    let
        defaultPerson =
            { name = "Jan"
            , surname = "Kowalski"
            , email = "abc@xyz.pl"
            , id = -9999
            }
    in
        List.filter (\person -> person.id == id) people
            |> List.head
            |> Maybe.withDefault defaultPerson
