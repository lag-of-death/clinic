module Patients.View exposing (..)

import Html.Attributes exposing (style)
import Html exposing (text, Html, div, button, ul, li, table, td, tr)
import Html.Events exposing (onClick)
import Patients.Types exposing (..)
import Styles exposing (menuButton)


view : List Patient -> Html Msg
view patients =
    if (List.isEmpty patients) then
        text "wait a sec..."
    else
        ul []
            (List.map
                (\patient ->
                    li []
                        [ text patient.name
                        , button
                            [ style menuButton
                            , onClick (NewUrl <| "/patients/" ++ (toString patient.id))
                            ]
                            [ text <| toString patient.id ]
                        ]
                )
                patients
            )


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
