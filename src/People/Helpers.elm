module People.Helpers exposing (addPerson, getPerson)


getPerson : a -> List { b | id : a } -> { b | id : a } -> { b | id : a }
getPerson id people default =
    List.filter (\person -> person.id == id) people
        |> List.head
        |> Maybe.withDefault default


addPerson : List { a | personal : { b | id : Int } } -> { a | personal : { b | id : Int } } -> List { a | personal : { b | id : Int } }
addPerson model entity =
    if List.isEmpty model then
        [ entity ]
    else
        List.map
            (\oldEntity ->
                if oldEntity.personal.id == entity.personal.id then
                    entity
                else
                    oldEntity
            )
            model
