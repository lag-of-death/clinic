module Visits.Helpers exposing (formatDate, addVisit, getVisit)

import Localization.Types exposing (..)
import Visits.Types exposing (Visit, defaultVisit)
import Date
import Date.Extra as Date


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
    let
        date =
            Date.fromTime (toFloat timestamp)

        year =
            Date.year date

        day =
            Date.day date

        month =
            Date.month date

        hour =
            Date.hour date

        dateAsString =
            if language == EN then
                Date.toFormattedString "M/d/y, h:mm a" date
            else
                toString day
                    ++ "."
                    ++ (toMonthString <| Date.monthNumber date)
                    ++ "."
                    ++ toString year
                    ++ ", "
                    ++ (toString hour)
                    ++ ":00"
    in
        dateAsString


toMonthString month =
    if month < 10 then
        ("0" ++ toString month)
    else
        (toString month)
