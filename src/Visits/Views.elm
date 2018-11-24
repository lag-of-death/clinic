module Visits.Views exposing (newVisitView, view, visitView)

import Array
import Dict
import Html exposing (Attribute, Html, div, input, label, li, option, select, table, td, text, tr, ul)
import Html.Attributes exposing (attribute, class, hidden, name, required, style, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Localization.Types exposing (..)
import People.Types
import People.Update
import Styles exposing (block, blockCentered, blockStretched)
import Types
import Views
import Visits.Helpers
import Visits.Types
    exposing
        ( NewVisitMsg(..)
        , Visit
        )


buttonActions visit locals =
    div []
        (Views.actions
            (onClick (People.Update.NewEntityUrl <| "/visits/" ++ String.fromInt visit.id))
            (onClick (People.Update.DelEntity visit.id))
            locals
        )


toID : String -> String
toID name =
    String.toLower name |> (\name_ -> name_ ++ "ID")


createAttrsForSelect x =
    { inputEl =
        [ onInput x.onInputMsg
        , required True
        , style "width" "160px"
        , name <| toID x.fieldName
        ]
    , label = x.label
    , choose = x.choose
    , people = x.people
    }


createSelect x =
    ( select x.inputEl <| List.concat [ [ selectTitle x.choose ], List.map personToOption x.people ], x.label )


addLabel ( element, label_ ) =
    [ label [] [ text label_ ], element ]


wrapWithDiv : List (Html msg) -> Html msg
wrapWithDiv elm =
    div [] elm


wrapEl =
    addLabel >> wrapWithDiv


createSelectRow =
    createAttrsForSelect >> createSelect >> wrapEl


newVisitView : Types.Model -> Html NewVisitMsg
newVisitView model =
    Html.form
        [ style "padding" "2px"
        , onSubmit SendNewVisit
        , Html.Attributes.action "/api/visits"
        , Html.Attributes.method "POST"
        ]
        [ createSelectRow { choose = model.locals.choose, onInputMsg = SetPatient, fieldName = "Patient", label = model.locals.patient, people = model.patients }
        , createSelectRow { choose = model.locals.choose, onInputMsg = SetNurse, fieldName = "Nurse", label = model.locals.nurse, people = model.nurses }
        , createSelectRow { choose = model.locals.choose, onInputMsg = SetDoctor, fieldName = "Doctor", label = model.locals.doctors, people = model.doctors }
        , wrapEl
            ( input
                [ type_ "number"
                , required True
                , onInput SetRoom
                , style "width" "148px"
                , name "room"
                ]
                []
            , model.locals.room
            )
        , wrapEl
            ( select
                [ onInput SetMonth, style "width" "160px", required True, name "month" ]
              <|
                List.concat
                    [ [ selectTitle model.locals.choose ]
                    , List.map
                        toMonthAsOption
                        (Dict.toList <|
                            filterMonths
                                (Dict.fromList <| attachIndicesToWords (toMonthsAsStrings model.locals.months) Array.empty 1)
                                model.currentMonth
                        )
                    ]
            , model.locals.month
            )
        , wrapEl
            ( select
                [ onInput SetDay
                , name "day"
                , style "width" "160px"
                , required True
                ]
              <|
                List.map toDayAsOption (List.range 1 model.newVisit.daysInMonth)
            , model.locals.day
            )
        , wrapEl ( whichDay model.language, model.locals.hour )
        , Html.button
            [ Html.Attributes.type_ "submit"
            ]
            [ text model.locals.add ]
        ]


whichDay lang =
    case lang of
        PL ->
            input
                [ required True
                , onInput SetHour
                , style "width" "148px"
                , type_ "number"
                , attribute "min" "9"
                , attribute "max" "17"
                , name "hour"
                ]
                []

        EN ->
            input
                [ required True
                , onInput SetHour
                , type_ "time"
                , attribute "step" "3600"
                , style "width" "148px"
                , attribute "min" "09:00:00"
                , attribute "max" "17:00:00"
                , name "hour_en"
                ]
                []


toDayAsOption dayAsInt =
    option [ value <| String.fromInt dayAsInt ] [ text <| String.fromInt dayAsInt ]


toMonthAsOption ( monthAsInt, monthName ) =
    option [ value <| String.fromInt monthAsInt ] [ text monthName ]


visitView visit locals language =
    table
        [ attribute "border" "1"
        , attribute "cellpadding" "10"
        , class "visits"
        , style "border" "2px solid black"
        , style "border-collapse" "collapse"
        ]
        [ tr []
            [ Html.th [] [ text locals.patient ]
            , Html.th [] [ text locals.doctor ]
            , Html.th [] [ text locals.nurse ]
            , Html.th [] [ text locals.date ]
            , Html.th [] [ text locals.roomNumber ]
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
                [ Visits.Helpers.formatDate language visit.date |> text ]
            , td []
                [ text <| String.fromInt visit.room
                ]
            ]
        ]


toCommaSeparated : List { c | personal : { b | name : String, surname : String } } -> String
toCommaSeparated list =
    List.map (\entity -> surnameAndName entity) list |> String.join ", "


view visits locals language =
    div []
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style "width" "30%" ]
                        [ text <| surnameAndName visit.patient
                        ]
                    , div [ style "width" "40%" ]
                        [ Visits.Helpers.formatDate language visit.date |> text ]
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
        [ value <| String.fromInt <| person.id ]
        [ text <| surnameAndName person ]


selectTitle choose =
    option [ attribute "value" "", attribute "disabled" "disabled", attribute "selected" "selected" ] [ text choose ]


filterMonths monthsDict chosenMonthIdx =
    Dict.filter (\idx val -> idx >= chosenMonthIdx) monthsDict


months monthsVar =
    Dict.fromList
        [ ( 1, monthsVar.january )
        , ( 2, monthsVar.february )
        , ( 3, monthsVar.march )
        , ( 4, monthsVar.april )
        , ( 5, monthsVar.may )
        , ( 6, monthsVar.june )
        , ( 7, monthsVar.july )
        , ( 8, monthsVar.august )
        , ( 9, monthsVar.september )
        , ( 10, monthsVar.october )
        , ( 11, monthsVar.november )
        , ( 12, monthsVar.december )
        ]


toMonthsAsStrings m =
    Array.fromList
        [ m.january
        , m.february
        , m.march
        , m.april
        , m.may
        , m.june
        , m.july
        , m.august
        , m.september
        , m.october
        , m.november
        , m.december
        ]


tail array =
    Array.slice 1 (Array.length array) array


attachIndicesToWords arrayOfStrings arrayOfTuples counter =
    if Array.isEmpty arrayOfStrings then
        Array.toList arrayOfTuples

    else
        let
            firstItem =
                Array.get 0 arrayOfStrings

            nextTuple =
                ( counter, Maybe.withDefault "?" firstItem )

            updatedArrayOfTuples =
                Array.push nextTuple arrayOfTuples
        in
        attachIndicesToWords
            (tail arrayOfStrings)
            updatedArrayOfTuples
            (counter + 1)
