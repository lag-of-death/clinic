module People.View exposing (..)

import Html.Attributes exposing (name, style, required, type_)
import Html exposing (text, Html, div, button, ul, label, li, table, td, tr, form, input)
import Html.Events exposing (onClick)
import People.Types exposing (..)
import Styles exposing (button, block, blockStretched, blockCentered)
import Views exposing (..)


withSpeciality : Doctor -> List (Html msg) -> List (Html msg)
withSpeciality doctor entryData =
    List.append entryData [ div [ style [ ( "width", "100px" ) ] ] [ text doctor.speciality ] ]


withIsDistrictInfo : Nurse -> List (Html msg) -> List (Html msg)
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
        [ div [ style [ ( "width", "100px" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
        , div []
            (actions
                onClick1
                onClick2
            )
        ]


doctorsList : List Doctor -> Html DoctorsMsg
doctorsList doctors =
    list
        (List.map
            (\doctor ->
                (withSpeciality doctor
                    (listSingleEntryShell
                        (onClick (NewDoctorsUrl <| "/doctors/" ++ (toString doctor.personalData.id)))
                        (onClick (DelDoctor doctor.personalData.id))
                        doctor
                    )
                )
            )
            doctors
        )


nursesList : List Nurse -> Html NursesMsg
nursesList nurses =
    list
        (List.map
            (\nurse ->
                (withIsDistrictInfo nurse
                    (listSingleEntryShell
                        (onClick
                            (NewNursesUrl <| "/nurses/" ++ (toString nurse.personalData.id))
                        )
                        (onClick (DelNurse nurse.personalData.id))
                        nurse
                    )
                )
            )
            nurses
        )


patientsList :
    List { b | personalData : { a | id : Int, name : String, surname : String } }
    -> Html PatientsMsg
patientsList patients =
    list
        (List.map
            (\patient ->
                (listSingleEntryShell
                    (onClick (NewPatientsUrl <| "/patients/" ++ (toString patient.personalData.id)))
                    (onClick (DelPatient patient.personalData.id))
                    patient
                )
            )
            patients
        )


patientsView :
    List { b | personalData : { a | id : Int, name : String, surname : String } }
    -> Html PatientsMsg
patientsView patients =
    view newPatient (patientsList patients)


doctorsView : List Doctor -> Html DoctorsMsg
doctorsView doctors =
    view newDoctor (doctorsList doctors)


view : Html msg -> Html msg -> Html msg
view newEntity people =
    div [ style block ]
        [ people
        , newEntity
        ]


newPatient : Html PatientsMsg
newPatient =
    newEntity (onClick (NewPatientsUrl <| "/patients/new")) "New patient"


newNurse : Html NursesMsg
newNurse =
    newEntity (onClick (NewNursesUrl <| "/nurses/new")) "New nurse"


newDoctor : Html DoctorsMsg
newDoctor =
    newEntity (onClick (NewDoctorsUrl <| "/doctors/new")) "New doctor"


newNurseView : Html NursesMsg
newNurseView =
    formToSubmit "nurses" <|
        List.concat
            [ newPersonFields
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text "District nurse" ]
                    , input [ type_ "checkbox", required True, name "isDistrictNurse", style Styles.button ]
                        []
                    ]
              ]
            , [ submitBtn ]
            ]


newDoctorView : Html DoctorsMsg
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
        [ style Styles.newPatientForm
        , Html.Attributes.action ("/api/" ++ endpoint)
        , Html.Attributes.method "POST"
        ]


newPatientView : Html msg
newPatientView =
    formToSubmit "patient" <| List.concat [ newPersonFields, [ submitBtn ] ]


patientView :
    { c
        | personalData :
            { b | email : String, id : a, name : String, surname : String }
    }
    -> Html msg
patientView patient =
    table [] (restTr patient)


restTr :
    { c
        | personalData :
            { b | email : String, id : a, name : String, surname : String }
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


doctorView :
    { c
        | personalData :
            { b | email : String, id : a, name : String, surname : String }
        , speciality : String
    }
    -> Html msg
doctorView doctor =
    table [] (List.concat [ (restTr doctor), [ specialityTr doctor.speciality ] ])


nurseView :
    { c
        | isDistrictNurse : Bool
        , personalData :
            { b | email : String, id : a, name : String, surname : String }
    }
    -> Html msg
nurseView nurse =
    table [] (List.concat [ (restTr nurse), [ districtNurseTr nurse.isDistrictNurse ] ])


nursesView : List Nurse -> Html NursesMsg
nursesView nurses =
    view newNurse (nursesList nurses)
