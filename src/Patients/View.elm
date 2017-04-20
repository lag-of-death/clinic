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
            [ ul [ style [ ( "width", "80%" ) ] ]
                (List.map
                    (\patient ->
                        li []
                            [ text patient.name
                            , Html.button
                                [ style Styles.button
                                , onClick (NewUrl <| "/patients/" ++ (toString patient.id))
                                ]
                                [ text <| toString patient.id ]
                            ]
                    )
                    patients
                )
            , div []
                [ Html.button
                    [ style Styles.button
                    , onClick (NewUrl <| "/patients/new")
                    ]
                    [ text "Dodaj pacjenta" ]
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
            [ label [] [ text "Nazwisko" ]
            , input [ required True, name "surname", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStreteched ]
            [ label [] [ text "Imię" ]
            , input [ required True, name "name", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStreteched ]
            [ label [] [ text "E-mail" ]
            , input
                [ Html.Attributes.type_ "email"
                , required True
                , name "mail"
                , style Styles.button
                ]
                []
            ]
        , Html.button
            [ Html.Attributes.type_ "submit"
            , style Styles.button
            ]
            [ text "Dodaj" ]
        ]


patientView : Patient -> Html a
patientView patient =
    table []
        [ tr []
            [ td []
                [ text "Nazwisko i imię:" ]
            , td []
                [ text patient.name ]
            ]
        , tr []
            [ td []
                [ text "ID:" ]
            , td []
                [ text <| toString <| patient.id ]
            ]
        ]
