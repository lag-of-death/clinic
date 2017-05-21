module Visits.View exposing (..)

import Visits.Types exposing (..)
import Views exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import People.Helpers exposing (..)
import People.Types exposing (..)
import Styles exposing (..)


buttonActions : Visit -> Html VisitsMsg
buttonActions visit =
    div []
        (actions
            (onClick (NewVisitsUrl <| "/visits/" ++ (toString visit.id)))
            (onClick (DelVisit visit.id))
        )


newVisitView : Html a
newVisitView =
    text "New Visit View"


visitView : Visit -> Html a
visitView visit =
    table [ attribute "border" "1", style [ ( "border", "2px solid black" ), ( "border-collapse", "collapse" ) ] ]
        [ tr []
            [ th [] [ text "Patient" ]
            , th [] [ text "Date" ]
            , th [] [ text "Nurses" ]
            , th [] [ text "Doctors" ]
            ]
        , tr []
            [ td []
                [ surnameAndName visit.patient |> text
                ]
            , td
                []
                [ visit.date |> text ]
            , td
                []
                [ toCommaSeparated visit.nurses |> text ]
            , td []
                [ toCommaSeparated visit.doctors |> text
                ]
            ]
        ]


toCommaSeparated : List { c | personalData : { b | name : String, surname : String } } -> String
toCommaSeparated list =
    List.map (\entity -> surnameAndName entity) list |> String.join ", "


view : List Visit -> Html VisitsMsg
view visits =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "100px" ) ] ]
                        [ text <| surnameAndName visit.patient
                        ]
                    , div [] [ text visit.date ]
                    , buttonActions visit
                    ]
                )
                visits
            )
        , newEntity (onClick (NewVisitsUrl <| "/visits/new")) "New visit"
        ]


surnameAndName : { a | personalData : { b | surname : String, name : String } } -> String
surnameAndName entity =
    entity.personalData.surname ++ " " ++ entity.personalData.name
