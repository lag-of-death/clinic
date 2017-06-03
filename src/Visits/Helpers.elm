module Visits.Helpers exposing (..)

import People.Types exposing (..)
import Visits.Types exposing (..)


getVisit : Int -> List Visit -> Visit
getVisit id visits =
    List.filter (\visit -> visit.id == id) visits
        |> List.head
        |> Maybe.withDefault defaultVisit


addVisit : List Visit -> Visit -> List Visit
addVisit model entity =
    if List.isEmpty model then
        [ entity ]
    else
        List.map
            (\oldEntity ->
                if oldEntity.id == entity.id then
                    entity
                else
                    oldEntity
            )
            model
