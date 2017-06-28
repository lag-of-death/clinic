module People.Views
    exposing
        ( patientsView
        , patientView
        , newPatientView
        , doctorsView
        , doctorView
        , newDoctorView
        , newNurseView
        , nursesView
        , nurseView
        )

import Html.Attributes exposing (name, style, required, type_)
import Html exposing (text, Html, div, label, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types as PT
import Styles exposing (block, blockStretched, blockCentered)
import Views exposing (newEntity, list, actions)


withSpeciality : PT.Doctor -> List (Html msg) -> List (Html msg)
withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


withIsDistrictInfo : PT.Nurse -> List (Html msg) -> List (Html msg)
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


listSingleEntryShell : Html.Attribute a -> Html.Attribute a -> { c | personalData : { b | surname : String, name : String } } -> List (Html a)
listSingleEntryShell onClick1 onClick2 a =
    let
        person =
            a.personalData
    in
        [ div [ style [ ( "width", "30%" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
        , div []
            (actions
                onClick1
                onClick2
            )
        ]


doctorsList : List PT.Doctor -> Html PT.DoctorsMsg
doctorsList doctors =
    list
        (List.map
            (\doctor ->
                withSpeciality doctor
                    (listSingleEntryShell
                        (onClick (PT.NewDoctorsUrl <| "/doctors/" ++ toString doctor.id))
                        (onClick (PT.DelDoctor doctor.id))
                        doctor
                    )
            )
            doctors
        )


nursesList : List PT.Nurse -> Html PT.NursesMsg
nursesList nurses =
    list
        (List.map
            (\nurse ->
                withIsDistrictInfo nurse
                    (listSingleEntryShell
                        (onClick
                            (PT.NewNursesUrl <| "/nurses/" ++ toString nurse.id)
                        )
                        (onClick (PT.DelNurse nurse.id))
                        nurse
                    )
            )
            nurses
        )


patientsList :
    List { a | id : Int, personalData : { b | name : String, surname : String } }
    -> Html PT.PatientsMsg
patientsList patients =
    list
        (List.map
            (\patient ->
                listSingleEntryShell
                    (onClick (PT.NewPatientsUrl <| "/patients/" ++ toString patient.id))
                    (onClick (PT.DelPatient patient.id))
                    patient
            )
            patients
        )


patientsView :
    List { a | id : Int, personalData : { b | name : String, surname : String } }
    -> Html PT.PatientsMsg
patientsView patients =
    view newPatient (patientsList patients)


doctorsView : List PT.Doctor -> Html PT.DoctorsMsg
doctorsView doctors =
    view newDoctor (doctorsList doctors)


view : Html msg -> Html msg -> Html msg
view newEntityBtn people =
    div [ style block ]
        [ people
        , newEntityBtn
        ]


newPatient : Html PT.PatientsMsg
newPatient =
    newEntity (onClick (PT.NewPatientsUrl <| "/patients/new")) "New patient"


newNurse : Html PT.NursesMsg
newNurse =
    newEntity (onClick (PT.NewNursesUrl <| "/nurses/new")) "New nurse"


newDoctor : Html PT.DoctorsMsg
newDoctor =
    newEntity (onClick (PT.NewDoctorsUrl <| "/doctors/new")) "New doctor"


newNurseView : Html PT.NursesMsg
newNurseView =
    formToSubmit "nurses" <|
        List.concat
            [ newPersonFields
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text "District nurse" ]
                    , input [ type_ "checkbox", name "isDistrictNurse", style Styles.button ]
                        []
                    ]
              ]
            , [ submitBtn ]
            ]


newDoctorView : Html PT.DoctorsMsg
newDoctorView =
    formToSubmit "doctors" <|
        List.concat
            [ newPersonFields
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text "Speciality" ]
                    , input [ required True, name "speciality", style Styles.button ]
                        []
                    ]
              ]
            , [ submitBtn ]
            ]


submitBtn : Html msg
submitBtn =
    Html.button
        [ Html.Attributes.type_ "submit"
        , style Styles.button
        , style Styles.submit
        ]
        [ text "Add" ]


newPersonFields : List (Html msg)
newPersonFields =
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
    ]


formToSubmit : String -> List (Html msg) -> Html msg
formToSubmit endpoint =
    form
        [ style Styles.form
        , Html.Attributes.action ("/api/" ++ endpoint)
        , Html.Attributes.method "POST"
        ]


newPatientView : Html msg
newPatientView =
    formToSubmit "patients" <| List.concat [ newPersonFields, [ submitBtn ] ]


patientView :
    { c
        | personalData :
            { b | email : String, name : String, surname : String }
        , id : a
    }
    -> Html msg
patientView patient =
    table [] (restTr patient)


restTr :
    { c
        | id : a
        , personalData : { b | email : String, name : String, surname : String }
    }
    -> List (Html msg)
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


doctorView :
    { c
        | personalData :
            { b | email : String, name : String, surname : String }
        , speciality : String
        , id : a
    }
    -> Html msg
doctorView doctor =
    table [] (List.concat [ restTr doctor, [ specialityTr doctor.speciality ] ])


nurseView :
    { c
        | isDistrictNurse : Bool
        , id : a
        , personalData :
            { b | email : String, name : String, surname : String }
    }
    -> Html msg
nurseView nurse =
    table [] (List.concat [ restTr nurse, [ districtNurseTr nurse.isDistrictNurse ] ])


nursesView : List PT.Nurse -> Html PT.NursesMsg
nursesView nurses =
    view newNurse (nursesList nurses)
