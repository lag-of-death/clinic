module Visits.Views exposing (newVisitView, visitView, view)

import Array
import People.Update
import Visits.Types
    exposing
        ( Visit
        )
import Html exposing (Html, div, label, text, li, ul, input, Attribute, tr, td, table, select, option)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (style, type_, attribute, required, name, class, hidden, value)
import Styles exposing (blockCentered, blockStretched, block)
import Views
import People.Types
import Types
import Visits.Helpers
import Visits.Types exposing (NewVisitMsg(..))
import Dict
import Localization.Types exposing (..)


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
            [ ( "width", "160px" )
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
        , style [ ( "padding", "2px" ) ]
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
                , style [ ( "width", "148px" ) ]
                , name "room"
                ]
                []
            , model.locals.room
            )
        , wrapEl
            ( select
                [ onInput SetMonth, style Styles.button, style [ ( "width", "160px" ) ], required True, name "month" ]
              <|
                List.concat
                    [ [ selectTitle model.locals.choose ]
                    , List.map
                        toMonthAsOption
                        (Dict.toList <|
                            filterMonths
                                (Dict.fromList <| attachIndicesToWords (toMonthsAsStrings model.locals.months) (Array.empty) 1)
                                model.currentMonth
                        )
                    ]
            , model.locals.month
            )
        , wrapEl
            ( select
                [ onInput SetDay
                , style Styles.button
                , name "day"
                , style [ ( "width", "160px" ) ]
                , required True
                ]
              <|
                List.map toDayAsOption (List.range 1 model.newVisit.daysInMonth)
            , model.locals.day
            )
        , wrapEl ( whichDay model.language, model.locals.hour )
        , Html.button
            [ Html.Attributes.type_ "submit"
            , style Styles.button
            , style Styles.submit
            ]
            [ text model.locals.add ]
        ]


whichDay lang =
    case lang of
        PL ->
            input
                [ required True
                , onInput SetHour
                , style Styles.button
                , style [ ( "width", "148px" ) ]
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
                , style Styles.button
                , attribute "step" "3600"
                , style [ ( "width", "148px" ) ]
                , attribute "min" "09:00:00"
                , attribute "max" "17:00:00"
                , name "hour_en"
                ]
                []


toDayAsOption dayAsInt =
    option [ value <| toString dayAsInt ] [ text <| toString dayAsInt ]


toMonthAsOption ( monthAsInt, monthName ) =
    option [ value <| toString monthAsInt ] [ text monthName ]


visitView visit locals language =
    table
        [ attribute "border" "1"
        , attribute "cellpadding" "10"
        , class "visits"
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
                [ Visits.Helpers.formatDate language visit.date |> text ]
            , td []
                [ text <| toString visit.room
                ]
            ]
        ]


toCommaSeparated : List { c | personal : { b | name : String, surname : String } } -> String
toCommaSeparated list =
    List.map (\entity -> surnameAndName entity) list |> String.join ", "


view visits locals language =
    div [ style block ]
        [ Views.list
            (List.map
                (\visit ->
                    [ div [ style [ ( "width", "30%" ) ] ]
                        [ text <| surnameAndName visit.patient
                        ]
                    , div [ style [ ( "width", "40%" ) ] ]
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
        [ value <| toString <| person.id ]
        [ text <| surnameAndName person ]


selectTitle choose =
    option [ attribute "value" "", attribute "disabled" "disabled", attribute "selected" "selected" ] [ text choose ]


filterMonths monthsDict chosenMonthIdx =
    Dict.filter (\idx val -> idx >= chosenMonthIdx) monthsDict


months months =
    Dict.fromList
        [ ( 1, months.january )
        , ( 2, months.february )
        , ( 3, months.march )
        , ( 4, months.april )
        , ( 5, months.may )
        , ( 6, months.june )
        , ( 7, months.july )
        , ( 8, months.august )
        , ( 9, months.september )
        , ( 10, months.october )
        , ( 11, months.november )
        , ( 12, months.december )
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
    if (Array.isEmpty arrayOfStrings) then
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
