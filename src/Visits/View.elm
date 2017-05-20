module Visits.View exposing (..)

import Visits.Types exposing (..)
import Views exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import People.Helpers exposing (..)
import Styles exposing (..)


buttonActions visit =
    div []
        (actions
            (onClick (NewVisitsUrl <| "/visits/" ++ (toString visit.id)))
            (onClick (DelVisit visit.id))
        )


visitView : Visit -> Html a
visitView visit =
    visit |> toString |> text


view visits =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "100px" ) ] ]
                        [ text <| visit.patient.personalData.surname ++ " " ++ visit.patient.personalData.name
                        ]
                    , div [] [ text visit.date ]
                    , buttonActions visit
                    ]
                )
                visits
            )
        ]
