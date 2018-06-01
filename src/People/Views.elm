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

import Html.Attributes exposing (name, style, required, type_, value)
import Html exposing (select, text, Html, div, label, table, td, tr, form, input, option)
import Html.Events exposing (onClick)
import People.Types as PT
import Styles exposing (block, blockStretched, blockCentered)
import Views exposing (newEntity, list, actions)
import People.Update as PU


withSpeciality : PT.Doctor -> List (Html msg) -> List (Html msg)
withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


withIsDistrictInfo : PT.Nurse -> List (Html msg) -> List (Html msg)
withIsDistrictInfo nurse entryData =
    List.append
        entryData
        [ div [ style [ ( "width", "100px" ) ] ]
            [ text <|
                if nurse.district then
                    "district nurse"
                else
                    ""
            ]
        ]


listSingleEntryShell : Html.Attribute a -> Html.Attribute a -> { c | personal : { b | surname : String, name : String } } -> List (Html a)
listSingleEntryShell onClick1 onClick2 a =
    let
        person =
            a.personal
    in
        [ div [ style [ ( "width", "30%" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
        , div []
            (actions
                onClick1
                onClick2
            )
        ]


doctorsList : List PT.Doctor -> Html (PU.Msg e)
doctorsList doctors =
    list
        (List.map
            (\doctor ->
                withSpeciality doctor
                    (listSingleEntryShell
                        (onClick (PU.NewEntityUrl <| "/doctors/" ++ toString doctor.id))
                        (onClick (PU.DelEntity doctor.id))
                        doctor
                    )
            )
            doctors
        )


nursesList : List PT.Nurse -> Html (PU.Msg e)
nursesList nurses =
    list
        (List.map
            (\nurse ->
                withIsDistrictInfo nurse
                    (listSingleEntryShell
                        (onClick
                            (PU.NewEntityUrl <| "/nurses/" ++ toString nurse.id)
                        )
                        (onClick (PU.DelEntity nurse.id))
                        nurse
                    )
            )
            nurses
        )


patientsList : List { a | id : Int, personal : { b | name : String, surname : String } } -> Html (PU.Msg e)
patientsList patients =
    list
        (List.map
            (\patient ->
                listSingleEntryShell
                    (onClick (PU.NewEntityUrl <| "/patients/" ++ toString patient.id))
                    (onClick (PU.DelEntity patient.id))
                    patient
            )
            patients
        )


patientsView : List { a | id : Int, personal : { b | name : String, surname : String } } -> Html (PU.Msg PT.Patient)
patientsView patients =
    view newPatient (patientsList patients)


newPatient : Html (PU.Msg PT.Patient)
newPatient =
    newEntity (onClick (PU.NewEntityUrl <| "/patients/new")) "New patient"


doctorsView : List PT.Doctor -> Html (PU.Msg e)
doctorsView doctors =
    view newDoctor (doctorsList doctors)


view : Html msg -> Html msg -> Html msg
view newEntityBtn people =
    div [ style block ]
        [ people
        , newEntityBtn
        ]


newNurse : Html (PU.Msg e)
newNurse =
    newEntity (onClick (PU.NewEntityUrl <| "/nurses/new")) "New nurse"


newDoctor : Html (PU.Msg e)
newDoctor =
    newEntity (onClick (PU.NewEntityUrl <| "/doctors/new")) "New doctor"


newNurseView : Html (PU.Msg e)
newNurseView =
    formToSubmit "nurses" <|
        List.concat
            [ newPersonFields
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text "District nurse" ]
                    , select [ name "district", style Styles.button ]
                        options
                    ]
              ]
            , [ submitBtn ]
            ]

options : List (Html msg)
options =
    [ option
        [ value "yes" ]
        [ text "YES" ]
    , option
        [ value "no" ]
        [ text "NO" ]
    ]


newDoctorView : Html (PU.Msg e)
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
        | personal :
            { b | email : String, name : String, surname : String }
        , id : a
    }
    -> Html msg
patientView patient =
    table [] (restTr patient)


restTr :
    { c
        | id : a
        , personal : { b | email : String, name : String, surname : String }
    }
    -> List (Html msg)
restTr person =
    [ tr []
        [ td []
            [ text "Surname:" ]
        , td []
            [ text person.personal.surname ]
        ]
    , tr []
        [ td []
            [ text "Name:" ]
        , td []
            [ text person.personal.name ]
        ]
    , tr []
        [ td []
            [ text "E-mail:" ]
        , td []
            [ text person.personal.email ]
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
        | personal :
            { b | email : String, name : String, surname : String }
        , speciality : String
        , id : a
    }
    -> Html (PU.Msg e)
doctorView doctor =
    table [] (List.concat [ restTr doctor, [ specialityTr doctor.speciality ] ])


nurseView :
    { c
        | district : Bool
        , id : a
        , personal :
            { b | email : String, name : String, surname : String }
    }
    -> Html (PU.Msg e)
nurseView nurse =
    table [] (List.concat [ restTr nurse, [ districtNurseTr nurse.district ] ])


nursesView : List PT.Nurse -> Html (PU.Msg e)
nursesView nurses =
    view newNurse (nursesList nurses)
