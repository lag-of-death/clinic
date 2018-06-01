module Visits.Helpers exposing (formatDate, addVisit, getVisit)

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


formatDate : Int -> String
formatDate dateAsString =
    Date.fromTime (toFloat dateAsString)
        |> Date.toFormattedString "EEEE, MMMM d, y 'at' h:mm a"
