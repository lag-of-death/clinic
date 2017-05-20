module Visits.View exposing (..)

import Visits.Types exposing (..)
import Views exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import People.Helpers exposing (..)
import Styles exposing (..)


visitsWithPatientsSurnames visits patients =
    List.map
        (\visit ->
            { visit
                | patient = .surname <| .personalData (getPerson visit.patient patients defaultPatient)
            }
        )
        visits


buttonActions visit =
    div []
        (actions
            (onClick (NewVisitsUrl <| "/visits/" ++ (toString visit.id)))
            (onClick (DelVisit visit.id))
        )


view visits =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "100px" ) ] ] [ text visit.patient ]
                    , div [] [ text visit.date ]
                    , buttonActions visit
                    ]
                )
                visits
            )
        ]
