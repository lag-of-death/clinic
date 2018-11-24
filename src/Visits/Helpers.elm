module Visits.Helpers exposing (addVisit, formatDate, getVisit)

import Localization.Types exposing (..)
import Time as Date
import Visits.Types exposing (Visit, defaultVisit)


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


formatDate : Language -> Int -> String
formatDate language timestamp =
    "TODO :: implement this"


toMonthString month =
    if month < 10 then
        "0" ++ String.fromInt month

    else
        String.fromInt month
