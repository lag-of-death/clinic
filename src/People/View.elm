module People.View exposing (..)

import Html.Attributes exposing (name, style, required)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types exposing (..)
import Styles exposing (button, block, blockStretched, blockCentered)


withSpeciality : Doctor -> List (Html Msg) -> List (Html Msg)
withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


withIsDistrictInfo : Nurse -> List (Html Msg) -> List (Html Msg)
withIsDistrictInfo nurse entryData =
    List.append
        entryData
        [ div [ style [ ( "width", "100px" ) ] ]
            [ text <|
                if nurse.isDistrictNurse then
                    "district nurse"
                else
                    ""
            ]
        ]


listSingleEntry : { b | personalData : { a | id : Int, name : String, surname : String } } -> String -> List (Html Msg)
listSingleEntry a whatPeople =
    let
        person =
            a.personalData
    in
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


doctorsList : String -> List Doctor -> Html Msg
doctorsList whatPeople doctors =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\doctor ->
                li [ style block, style blockCentered, style blockStretched ]
                    (withSpeciality doctor (listSingleEntry doctor whatPeople))
            )
            doctors
        )


nursesList : String -> List Nurse -> Html Msg
nursesList whatPeople nurses =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\nurse ->
                li [ style block, style blockCentered, style blockStretched ]
                    (withIsDistrictInfo nurse (listSingleEntry nurse whatPeople))
            )
            nurses
        )


peopleList : String -> List { b | personalData : { a | name : String, surname : String, id : Int } } -> Html Msg
peopleList whatPeople people =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\person ->
                li [ style block, style blockCentered, style blockStretched ]
                    (listSingleEntry person whatPeople)
            )
            people
        )


patientsView : List { b | personalData : { a | id : Int, name : String, surname : String } } -> Html Msg
patientsView people =
    view newPatient (peopleList "patients" people)


doctorsView : List Doctor -> Html Msg
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
        [ div [ style block, style blockCentered, style blockStretched ]
            [ label [] [ text "Surname" ]
            , input [ required True, name "surname", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStretched ]
            [ label [] [ text "Name" ]
            , input [ required True, name "name", style Styles.button ]
                []
            ]
        , div [ style block, style blockCentered, style blockStretched ]
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
patientView person =
    table [] (restTr person)


restTr : { b | personalData : { email : String, id : a, name : String, surname : String } } -> List (Html msg)
restTr person =
    [ tr []
        [ td []
            [ text "Surname:" ]
        , td []
            [ text person.personalData.surname ]
        ]
    , tr []
        [ td []
            [ text "Name:" ]
        , td []
            [ text person.personalData.name ]
        ]
    , tr []
        [ td []
            [ text "E-mail:" ]
        , td []
            [ text person.personalData.email ]
        ]
    , tr []
        [ td []
            [ text "ID:" ]
        , td []
            [ text <| toString <| person.personalData.id ]
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


districtNurseTr : Bool -> Html msg
districtNurseTr isDistrict =
    tr []
        [ td []
            [ text "District nurse:" ]
        , td []
            [ text <|
                if isDistrict then
                    "yes"
                else
                    "no"
            ]
        ]


doctorView : Doctor -> Html a
doctorView person =
    table [] (List.concat [ (restTr person), [ specialityTr person.speciality ] ])


nurseView : Nurse -> Html a
nurseView person =
    table [] (List.concat [ (restTr person), [ districtNurseTr person.isDistrictNurse ] ])


nursesView : List Nurse -> Html Msg
nursesView people =
    view (div [] []) (nursesList "nurses" people)
