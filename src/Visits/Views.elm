module Visits.Views exposing (newVisitView, visitView, view)

import People.Update
import Visits.Types
    exposing
        ( Visit
        , NewVisitModel
        , NewVisitMsg(DecDoctors, IncDoctors, IncNurses, DecNurses)
        )
import Html exposing (Html, div, label, text, li, ul, input, Attribute, tr, td, table)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, type_, attribute, required, name, hidden)
import Styles exposing (blockCentered, blockStretched, block)
import Views
import Visits.Helpers


buttonActions : Visit -> Html (People.Update.Msg e)
buttonActions visit =
    div []
        (Views.actions
            (onClick (People.Update.NewEntityUrl <| "/visits/" ++ toString visit.id))
            (onClick (People.Update.DelEntity visit.id))
        )


listOf :
    Attribute msg
    -> Attribute msg
    -> String
    -> String
    -> Int
    -> Bool
    -> Html msg
listOf incAction decAction label_ inputName numOf isRequired =
    div [ style block, style blockCentered, style blockStretched ]
        [ label [] [ text label_ ]
        , div [ style block, style blockCentered, style blockStretched ] <|
            [ ul [ style [ ( "list-style", "none" ), ( "margin", "6px" ) ] ]
                (List.repeat numOf
                    (li [ style [ ( "margin", "2px" ) ] ]
                        [ input [ type_ "number", required isRequired, name inputName, style Styles.button ]
                            []
                        ]
                    )
                )
            , Html.button [ type_ "button", decAction, hidden (numOf <= 1) ]
                [ text "-" ]
            , Html.button [ type_ "button", incAction ]
                [ text "+" ]
            ]
        ]


newVisitView : NewVisitModel -> Html NewVisitMsg
newVisitView newVisit =
    Html.form
        [ style Styles.form
        , Html.Attributes.action "/api/visits"
        , Html.Attributes.method "POST"
        ]
        [ div [ style block, style blockCentered, style blockStretched ]
            [ label [] [ text "PatientID" ]
            , input [ type_ "number", required True, name "patientID", style Styles.button, style [ ( "width", "30%" ) ] ]
                []
            ]
        , div [ style block, style blockCentered, style blockStretched ]
            [ label [] [ text "Date" ]
            , input
                [ type_ "datetime-local"
                , attribute "step" "3600"
                , required True
                , name "date"
                , style Styles.button
                ]
                []
            ]
        , listOf
            (onClick IncDoctors)
            (onClick DecDoctors)
            "DoctorID"
            "doctorID[]"
            newVisit.numOfDoctors
            True
        , listOf
            (onClick IncNurses)
            (onClick DecNurses)
            "NurseID"
            "nurseID[]"
            newVisit.numOfNurses
            False
        , Html.button
            [ Html.Attributes.type_ "submit"
            , style Styles.button
            , style Styles.submit
            ]
            [ text "Add" ]
        ]


visitView : Visit -> Html a
visitView visit =
    table
        [ attribute "border" "1"
        , attribute "cellpadding" "10"
        , style [ ( "border", "2px solid black" ), ( "border-collapse", "collapse" ) ]
        ]
        [ tr []
            [ Html.th [ style Styles.th ] [ text "Patient" ]
            , Html.th [ style Styles.th ] [ text "Date" ]
            , Html.th [ style Styles.th ] [ text "Nurses" ]
            , Html.th [ style Styles.th ] [ text "Doctors" ]
            ]
        , tr []
            [ td []
                [ surnameAndName visit.patient |> text
                ]
            , td
                []
                [ Visits.Helpers.formatDate visit.date |> text ]
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


view : List Visit -> Html (People.Update.Msg e)
view visits =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "30%" ) ] ]
                        [ text <| surnameAndName visit.patient
                        ]
                    , div [ style [ ( "width", "40%" ) ] ]
                        [ Visits.Helpers.formatDate visit.date |> text ]
                    , buttonActions visit
                    ]
                )
                visits
            )
        , Views.newEntity (onClick (People.Update.NewEntityUrl <| "/visits/new")) "New visit"
        ]


surnameAndName : { a | personalData : { b | surname : String, name : String } } -> String
surnameAndName entity =
    entity.personalData.surname ++ " " ++ entity.personalData.name
