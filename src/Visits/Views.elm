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


buttonActions : Visit -> Html (People.Update.Msg e)
buttonActions visit =
    div []
        (Views.actions
            (onClick (People.Update.NewEntityUrl <| "/visits/" ++ toString visit.id))
            (onClick (People.Update.DelEntity visit.id))
        )


toID : String -> String
toID name =
    String.toLower name |> (\name_ -> name_ ++ "ID")


createAttrsForSelect : ( String -> msg, String, a ) -> ( List (Attribute msg), String, a )
createAttrsForSelect ( onInputMsg, fieldName, people ) =
    ( [ onInput onInputMsg
      , required True
      , style Styles.button
      , style
            [ ( "width", "30%" )
            ]
      , name <| toID fieldName
      ]
    , fieldName
    , people
    )


createSelect :
    ( List (Attribute b), c, List { a | id : Int, personal : People.Types.Person } )
    -> ( Html b, c )
createSelect ( inputEl, fieldName, people ) =
    ( select inputEl <| List.concat [ [ selectTitle ], (List.map personToOption people) ], fieldName )


addLabel : ( Html msg, String ) -> List (Html msg)
addLabel ( element, text_ ) =
    [ label [] [ text text_ ], element ]


wrapWithDiv : List (Html msg) -> Html msg
wrapWithDiv elm =
    div [ style block, style blockCentered, style blockStretched ] elm


wrapEl : ( Html msg, String ) -> Html msg
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
        [ createSelectRow ( SetPatient, "Patient", model.patients )
        , createSelectRow ( SetNurse, "Nurse", model.nurses )
        , createSelectRow ( SetDoctor, "Doctor", model.doctors )
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
            , "Room"
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
            , "Date"
            )
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
            , Html.th [ style Styles.th ] [ text "Doctor" ]
            , Html.th [ style Styles.th ] [ text "Nurse" ]
            , Html.th [ style Styles.th ] [ text "Date" ]
            , Html.th [ style Styles.th ] [ text "Room number" ]
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


surnameAndName : { a | personal : { b | surname : String, name : String } } -> String
surnameAndName entity =
    entity.personal.surname ++ " " ++ entity.personal.name


personToOption : { a | personal : People.Types.Person, id : Int } -> Html b
personToOption person =
    option
        [ value <| toString <| person.id ]
        [ text <| surnameAndName person ]


selectTitle : Html msg
selectTitle =
    option [ attribute "value" "", attribute "disabled" "disabled", attribute "selected" "selected" ] [ text "Choose" ]
