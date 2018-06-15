module Visits.Views exposing (newVisitView, visitView, view)

import People.Update
import Visits.Types
    exposing
        ( Visit
        )
import Html exposing (Html, div, label, text, li, ul, input, Attribute, tr, td, table, select, option)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (style, type_, attribute, required, name, hidden, value)
import Styles exposing (blockCentered, blockStretched, block)
import Views
import People.Types
import Types
import Visits.Helpers
import Visits.Types exposing (NewVisitMsg(..))


buttonActions visit locals =
    div []
        (Views.actions
            (onClick (People.Update.NewEntityUrl <| "/visits/" ++ toString visit.id))
            (onClick (People.Update.DelEntity visit.id))
            locals
        )


toID : String -> String
toID name =
    String.toLower name |> (\name_ -> name_ ++ "ID")


createAttrsForSelect ( choose, onInputMsg, fieldName, label, people ) =
    ( [ onInput onInputMsg
      , required True
      , style Styles.button
      , style
            [ ( "width", "30%" )
            ]
      , name <| toID fieldName
      ]
    , label
    , choose
    , people
    )


createSelect ( inputEl, label, choose, people ) =
    ( select inputEl <| List.concat [ [ selectTitle choose ], (List.map personToOption people) ], label )


addLabel ( element, label_ ) =
    [ label [] [ text label_ ], element ]


wrapWithDiv : List (Html msg) -> Html msg
wrapWithDiv elm =
    div [ style block, style blockCentered, style blockStretched ] elm


wrapEl =
    addLabel >> wrapWithDiv


createSelectRow =
    createAttrsForSelect >> createSelect >> wrapEl


newVisitView : Types.Model -> Html NewVisitMsg
newVisitView model =
    Html.form
        [ style Styles.form
        , onSubmit SendNewVisit
        , Html.Attributes.action "/api/visits"
        , Html.Attributes.method "POST"
        ]
        [ createSelectRow ( model.locals.choose, SetPatient, "Patient", model.locals.patient, model.patients )
        , createSelectRow ( model.locals.choose, SetNurse, "Nurse", model.locals.nurse, model.nurses )
        , createSelectRow ( model.locals.choose, SetDoctor, "Doctor", model.locals.doctors, model.doctors )
        , wrapEl
            ( input
                [ type_ "number"
                , required True
                , style Styles.button
                , onInput SetRoom
                , style [ ( "width", "30%" ) ]
                , name "room"
                ]
                []
            , model.locals.room
            )
        , wrapEl
            ( input
                [ type_ "datetime-local"
                , attribute "step" "3600"
                , name "date"
                , style Styles.button
                , required True
                , onInput SetDate
                ]
                []
            , model.locals.date
            )
        , Html.button
            [ Html.Attributes.type_ "submit"
            , style Styles.button
            , style Styles.submit
            ]
            [ text model.locals.add ]
        ]


visitView visit locals =
    table
        [ attribute "border" "1"
        , attribute "cellpadding" "10"
        , style [ ( "border", "2px solid black" ), ( "border-collapse", "collapse" ) ]
        ]
        [ tr []
            [ Html.th [ style Styles.th ] [ text locals.patient ]
            , Html.th [ style Styles.th ] [ text locals.doctor ]
            , Html.th [ style Styles.th ] [ text locals.nurse ]
            , Html.th [ style Styles.th ] [ text locals.date ]
            , Html.th [ style Styles.th ] [ text locals.roomNumber ]
            ]
        , tr []
            [ td []
                [ surnameAndName visit.patient |> text
                ]
            , td []
                [ surnameAndName visit.doctor |> text
                ]
            , td []
                [ surnameAndName visit.nurse |> text
                ]
            , td
                []
                [ Visits.Helpers.formatDate visit.date |> text ]
            , td []
                [ text <| toString visit.room
                ]
            ]
        ]


toCommaSeparated : List { c | personal : { b | name : String, surname : String } } -> String
toCommaSeparated list =
    List.map (\entity -> surnameAndName entity) list |> String.join ", "


view visits locals =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "30%" ) ] ]
                        [ text <| surnameAndName visit.patient
                        ]
                    , div [ style [ ( "width", "40%" ) ] ]
                        [ Visits.Helpers.formatDate visit.date |> text ]
                    , buttonActions visit locals
                    ]
                )
                visits
            )
        , Views.newEntity (onClick (People.Update.NewEntityUrl <| "/visits/new")) locals.newVisit
        ]


surnameAndName : { a | personal : { b | surname : String, name : String } } -> String
surnameAndName entity =
    entity.personal.surname ++ " " ++ entity.personal.name


personToOption : { a | personal : People.Types.Person, id : Int } -> Html b
personToOption person =
    option
        [ value <| toString <| person.id ]
        [ text <| surnameAndName person ]


selectTitle choose =
    option [ attribute "value" "", attribute "disabled" "disabled", attribute "selected" "selected" ] [ text choose ]
