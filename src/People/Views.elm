module People.Views exposing
    ( doctorView
    , doctorsView
    , newDoctorView
    , newNurseView
    , newPatientView
    , nurseView
    , nursesView
    , patientView
    , patientsView
    , staffView
    )

import Html exposing (Html, div, form, input, label, option, p, select, span, table, td, text, tr)
import Html.Attributes exposing (name, required, style, type_, value)
import Html.Events exposing (onClick)
import People.Types as PT
import People.Update as PU
import Styles exposing (block, blockCentered, blockStretched)
import Views exposing (actions, list, newEntity)


withSpeciality doctor entryData locals =
    List.append entryData
        [ div
            [ style "width" "100px" ]
            [ text <| translateSpeciality locals <| doctor.speciality ]
        ]


withIsDistrictInfo nurse entryData districtNurse =
    List.append
        entryData
        [ div [ style "width" "100px" ]
            [ text <|
                if nurse.district then
                    districtNurse

                else
                    ""
            ]
        ]


listSingleEntryShell onClick1 onClick2 entity locals =
    let
        person =
            entity.personal
    in
    [ div [ style "width" "30%" ] [ text <| person.surname ++ " " ++ person.name ]
    , div []
        (actions
            onClick1
            onClick2
            locals
        )
    ]


doctorsList doctors locals =
    list
        (List.map
            (\doctor ->
                withSpeciality
                    doctor
                    (listSingleEntryShell
                        (onClick (PU.NewEntityUrl <| "/doctors/" ++ String.fromInt doctor.id))
                        (onClick (PU.DelEntity doctor.id))
                        doctor
                        locals
                    )
                    locals
            )
            doctors
        )


nursesList nurses locals =
    list
        (List.map
            (\nurse ->
                withIsDistrictInfo nurse
                    (listSingleEntryShell
                        (onClick
                            (PU.NewEntityUrl <| "/nurses/" ++ String.fromInt nurse.id)
                        )
                        (onClick (PU.DelEntity nurse.id))
                        nurse
                        locals
                    )
                    locals.districtNurse
            )
            nurses
        )


patientsList patients locals =
    list
        (List.map
            (\patient ->
                listSingleEntryShell
                    (onClick (PU.NewEntityUrl <| "/patients/" ++ String.fromInt patient.id))
                    (onClick (PU.DelEntity patient.id))
                    patient
                    locals
            )
            patients
        )


translate locals who =
    case who of
        "nurse" ->
            locals.nurse

        "doctor" ->
            locals.doctor

        _ ->
            ""


staffView staff locals =
    div
        [ style "padding" "20px 160px", style "background" "lightblue" ]
        (List.map
            (\staffMember ->
                div
                    [ style "display" "flex", style "justify-content" "space-between" ]
                    [ p [] [ text <| staffMember.personal.name ++ " " ++ staffMember.personal.surname ]
                    , p [] [ text <| translate locals <| staffMember.who ]
                    ]
            )
            staff
        )


patientsView patients locals =
    view (newPatient locals.newPatient) (patientsList patients locals)


newPatient newPatientLabel =
    newEntity (onClick (PU.NewEntityUrl <| "/patients/new")) newPatientLabel


doctorsView doctors locals =
    view (newDoctor locals.newDoctor) (doctorsList doctors locals)


view : Html msg -> Html msg -> Html msg
view newEntityBtn people =
    div []
        [ people
        , newEntityBtn
        ]


newNurse newNurseVar =
    newEntity (onClick (PU.NewEntityUrl <| "/nurses/new")) newNurseVar


newDoctor newDoctorVar =
    newEntity (onClick (PU.NewEntityUrl <| "/doctors/new")) newDoctorVar


newNurseView locals =
    formToSubmit "nurses" <|
        List.concat
            [ newPersonFields locals
            , [ div []
                    [ label [] [ text locals.districtNurse ]
                    , select [ name "district" ]
                        (options locals)
                    ]
              ]
            , [ submitBtn locals.add ]
            ]


options locals =
    [ option
        [ value "yes" ]
        [ text locals.yes ]
    , option
        [ value "no" ]
        [ text locals.no ]
    ]


doctorSpecialities locals =
    [ option
        [ value "surgeon" ]
        [ text locals.surgeon ]
    , option
        [ value "pediatrician" ]
        [ text locals.pediatrician ]
    , option
        [ value "laryngologist" ]
        [ text locals.laryngologist ]
    , option
        [ value "dentist" ]
        [ text locals.dentist ]
    , option
        [ value "endocrinologist" ]
        [ text locals.endocrinologist ]
    , option
        [ value "gastrologist" ]
        [ text locals.gastrologist ]
    ]


newDoctorView locals =
    formToSubmit "doctors" <|
        List.concat
            [ newPersonFields locals
            , [ div []
                    [ label [] [ text locals.speciality ]
                    , select [ required True, name "speciality" ]
                        (doctorSpecialities locals)
                    ]
              ]
            , [ submitBtn locals.add ]
            ]


submitBtn add =
    Html.button
        [ Html.Attributes.type_ "submit"
        ]
        [ text add ]


createInput ( name_, label_, type_ ) =
    ( input
        [ required True
        , name name_
        , Html.Attributes.type_ type_
        ]
        []
    , label_
    )


addLabel : ( Html msg, String ) -> List (Html msg)
addLabel ( inputEl, name_ ) =
    [ label [] [ text name_ ]
    , inputEl
    ]


wrapWithDiv : List (Html msg) -> Html msg
wrapWithDiv inputWithLabel =
    div [] inputWithLabel


createFieldRow =
    createInput >> addLabel >> wrapWithDiv


newPersonFields locals =
    [ createFieldRow ( "surname", locals.surname, "text" )
    , createFieldRow ( "name", locals.name, "text" )
    , createFieldRow ( "e-mail", locals.email, "email" )
    ]


formToSubmit : String -> List (Html msg) -> Html msg
formToSubmit endpoint =
    form
        [ Html.Attributes.action ("/api/" ++ endpoint)
        , Html.Attributes.method "POST"
        ]


newPatientView locals =
    formToSubmit "patients" <| List.concat [ newPersonFields locals, [ submitBtn locals.add ] ]


patientView patient locals =
    table [] (restTr patient locals)


rightAligned =
    style "text-align" "right"


recordStyle =
    style "padding" "10px"


restTr person locals =
    [ tr []
        [ td [ recordStyle ]
            [ text <| locals.surname ]
        , td [ rightAligned, recordStyle ]
            [ text person.personal.surname ]
        ]
    , tr []
        [ td [ recordStyle ]
            [ text <| locals.name ]
        , td [ rightAligned, recordStyle ]
            [ text person.personal.name ]
        ]
    , tr []
        [ td [ recordStyle ]
            [ text <| locals.email ]
        , td [ rightAligned, recordStyle ]
            [ text person.personal.email ]
        ]
    , tr []
        [ td [ recordStyle ]
            [ text <| locals.id ]
        , td [ rightAligned, recordStyle ]
            [ text <| String.fromInt <| person.id ]
        ]
    ]


translateSpeciality locals speciality =
    case speciality of
        "surgeon" ->
            locals.surgeon

        "pediatrician" ->
            locals.pediatrician

        "laryngologist" ->
            locals.laryngologist

        "dentist" ->
            locals.dentist

        "endocrinologist" ->
            locals.endocrinologist

        "gastrologist" ->
            locals.gastrologist

        notTranslated ->
            notTranslated


specialityTr speciality locals =
    tr []
        [ td []
            [ text locals.speciality ]
        , td [ rightAligned ]
            [ text <| translateSpeciality locals <| speciality ]
        ]


districtNurseTr isDistrict locals =
    tr []
        [ td []
            [ text locals.districtNurse ]
        , td [ rightAligned ]
            [ text <|
                if isDistrict then
                    locals.yes

                else
                    locals.no
            ]
        ]


doctorView doctor locals =
    table [] (List.concat [ restTr doctor locals, [ specialityTr doctor.speciality locals ] ])


nurseView nurse locals =
    table [] (List.concat [ restTr nurse locals, [ districtNurseTr nurse.district locals ] ])


nursesView nurses locals =
    view (newNurse locals.newNurse) (nursesList nurses locals)
