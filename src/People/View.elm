module People.View exposing (..)

import Html.Attributes exposing (name, style, required)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types exposing (..)
import Styles exposing (button, block, blockStretched, blockCentered)


withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


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


listSingleEntryShell onClick1 onClick2 a whatPeople =
    let
        person =
            a.personalData
    in
        [ div [ style [ ( "width", "100px" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
        , div []
            [ Html.button
                [ style Styles.button
                , onClick1
                ]
                [ text "Details" ]
            , Html.button
                [ style Styles.button
                , style [ ( "margin-left", "4px" ) ]
                , onClick2
                ]
                [ text "Delete" ]
            ]
        ]


doctorsList doctors =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\doctor ->
                li [ style block, style blockCentered, style blockStretched ]
                    (withSpeciality doctor
                        (listSingleEntryShell
                            (onClick (NewDoctorsUrl <| "/doctors/" ++ (toString doctor.personalData.id)))
                            (onClick (DelDoctor doctor.personalData.id))
                            doctor
                            "doctors"
                        )
                    )
            )
            doctors
        )


nursesList nurses =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\nurse ->
                li [ style block, style blockCentered, style blockStretched ]
                    (withIsDistrictInfo nurse
                        (listSingleEntryShell
                            (onClick
                                (NewNursesUrl <| "/nurses/" ++ (toString nurse.personalData.id))
                            )
                            (onClick (DelNurse nurse.personalData.id))
                            nurse
                            "nurses"
                        )
                    )
            )
            nurses
        )


patientsList patients =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\patient ->
                li [ style block, style blockCentered, style blockStretched ]
                    (listSingleEntryShell
                        (onClick (NewPatientsUrl <| "/patients/" ++ (toString patient.personalData.id)))
                        (onClick (DelPatient patient.personalData.id))
                        patient
                        "patients"
                    )
            )
            patients
        )


patientsView patients =
    view newPatient (patientsList patients)


doctorsView doctors =
    view (div [] []) (doctorsList doctors)


view newPatient people =
    div [ style block ]
        [ people
        , newPatient
        ]


newPatient =
    div []
        [ Html.button
            [ style Styles.button
            , onClick (NewPatientsUrl <| "/patients/new")
            ]
            [ text "New patient" ]
        ]


newPatientView =
    form
        [ style Styles.newPatientForm
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


patientView patient =
    table [] (restTr patient)


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


specialityTr speciality =
    tr []
        [ td []
            [ text "Speciality:" ]
        , td []
            [ text speciality ]
        ]


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


doctorView doctor =
    table [] (List.concat [ (restTr doctor), [ specialityTr doctor.speciality ] ])


nurseView nurse =
    table [] (List.concat [ (restTr nurse), [ districtNurseTr nurse.isDistrictNurse ] ])


nursesView nurses =
    view (div [] []) (nursesList nurses)
