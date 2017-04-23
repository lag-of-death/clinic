module People.View exposing (..)

import Html.Attributes exposing (name, style, required)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types exposing (..)
import Styles exposing (button, block, blockStreteched, blockCentered)


peopleList : String -> List Person -> Html Msg
peopleList whatPeople people =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\person ->
                li [ style block, style blockCentered, style blockStreteched ]
                    [ text <| person.surname ++ " " ++ person.name
                    , div []
                        [ Html.button
                            [ style Styles.button
                            , onClick (NewUrl <| "/" ++ whatPeople ++ "/" ++ (toString person.id))
                            ]
                            [ text "Details" ]
                        , Html.button
                            [ style Styles.button
                            , style [ ( "margin-left", "4px" ) ]
                            , onClick (DelPerson person.id)
                            ]
                            [ text "Delete" ]
                        ]
                    ]
            )
            people
        )


peopleView : String -> List Person -> Html Msg
peopleView whatPeople people =
    view whatPeople newPatient people


patientsView : List Person -> Html Msg
patientsView people =
    peopleView "patients" people


view : String -> Html Msg -> List Person -> Html Msg
view whatPeople newPerson people =
    if (List.isEmpty people) then
        text "Processing..."
    else
        div [ style block ]
            [ peopleList whatPeople people
            , newPerson
            ]


newPatient : Html Msg
newPatient =
    div []
        [ Html.button
            [ style Styles.button
            , onClick (NewUrl <| "/patients/new")
            ]
            [ text "New patient" ]
        ]


newPersonView : Html a
newPersonView =
    form
        [ style Styles.newPersonForm
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


personView : Person -> Html a
personView person =
    table []
        [ tr []
            [ td []
                [ text "Surname:" ]
            , td []
                [ text person.surname ]
            ]
        , tr []
            [ td []
                [ text "Name:" ]
            , td []
                [ text person.name ]
            ]
        , tr []
            [ td []
                [ text "E-mail:" ]
            , td []
                [ text person.email ]
            ]
        , tr []
            [ td []
                [ text "ID:" ]
            , td []
                [ text <| toString <| person.id ]
            ]
        ]
