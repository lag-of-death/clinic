module Patients.View exposing (..)

import Html.Attributes exposing (name, style, required)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import Patients.Types exposing (..)
import Styles exposing (button, block, blockStreteched, blockCentered)


view : List Patient -> Html Msg
view patients =
    if (List.isEmpty patients) then
        text "Processing..."
    else
        div [ style block ]
            [ ul [ style [ ( "width", "70%" ) ] ]
                (List.map
                    (\patient ->
                        li [ style block, style blockCentered, style blockStreteched ]
                            [ text <| patient.surname ++ " " ++ patient.name
                            , Html.button
                                [ style Styles.button
                                , onClick (NewUrl <| "/patients/" ++ (toString patient.id))
                                ]
                                [ text "Details" ]
                            ]
                    )
                    patients
                )
            , div []
                [ Html.button
                    [ style Styles.button
                    , onClick (NewUrl <| "/patients/new")
                    ]
                    [ text "New patient" ]
                ]
            ]


newPatientView : Html a
newPatientView =
    form
        [ style Styles.newPatientForm
        , Html.Attributes.action "/api/patients/"
        , Html.Attributes.method "POST"
        ]
        [ div [ style block, style blockCentered, style blockStreteched ]
            [ label [] [ text "Surname" ]
            , input [ required True, name "surname", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStreteched ]
            [ label [] [ text "Name" ]
            , input [ required True, name "name", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStreteched ]
            [ label [] [ text "E-mail" ]
            , input
                [ Html.Attributes.type_ "email"
                , required True
                , name "email"
                , style Styles.button
                ]
                []
            ]
        , Html.button
            [ Html.Attributes.type_ "submit"
            , style Styles.button
            ]
            [ text "Add" ]
        ]


patientView : Patient -> Html a
patientView patient =
    table []
        [ tr []
            [ td []
                [ text "Surname:" ]
            , td []
                [ text patient.surname ]
            ]
        , tr []
            [ td []
                [ text "Name:" ]
            , td []
                [ text patient.name ]
            ]
        , tr []
            [ td []
                [ text "E-mail:" ]
            , td []
                [ text patient.email ]
            ]
        , tr []
            [ td []
                [ text "ID:" ]
            , td []
                [ text <| toString <| patient.id ]
            ]
        ]
