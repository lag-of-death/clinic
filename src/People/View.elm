module People.View exposing (..)

import Html.Attributes exposing (name, style, required)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types exposing (..)
import Styles exposing (button, block, blockStreteched, blockCentered)


withSpeciality : Doctor Person -> List (Html Msg) -> List (Html Msg)
withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


listSingleEntry :
    { a | name : String, surname : String, id : Int }
    -> String
    -> List (Html Msg)
listSingleEntry person whatPeople =
    [ div [ style [ ( "width", "100px" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
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


doctorsList : String -> List (Doctor Person) -> Html Msg
doctorsList whatPeople doctors =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\doctor ->
                li [ style block, style blockCentered, style blockStreteched ]
                    (withSpeciality doctor (listSingleEntry doctor whatPeople))
            )
            doctors
        )


peopleList : String -> List Person -> Html Msg
peopleList whatPeople people =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\person ->
                li [ style block, style blockCentered, style blockStreteched ]
                    (listSingleEntry person whatPeople)
            )
            people
        )


patientsView : List Person -> Html Msg
patientsView people =
    view newPatient (peopleList "patients" people)


doctorsView : List (Doctor Person) -> Html Msg
doctorsView people =
    view (div [] []) (doctorsList "doctors" people)


view : Html Msg -> Html Msg -> Html Msg
view newPerson people =
    div [ style block ]
        [ people
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
    table [] (restTr person)


restTr : { b | email : String, id : a, name : String, surname : String } -> List (Html msg)
restTr person =
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


specialityTr : String -> Html msg
specialityTr speciality =
    tr []
        [ td []
            [ text "Speciality:" ]
        , td []
            [ text speciality ]
        ]


doctorView : Doctor Person -> Html a
doctorView person =
    table [] (List.concat [ (restTr person), [ specialityTr person.speciality ] ])
