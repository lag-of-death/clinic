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
        , staffView
        )

import Html.Attributes exposing (name, style, required, type_, value)
import Html exposing (select, text, Html, div, label, p, table, td, tr, form, input, option, span)
import Html.Events exposing (onClick)
import People.Types as PT
import Styles exposing (block, blockStretched, blockCentered)
import Views exposing (newEntity, list, actions)
import People.Update as PU


withSpeciality doctor entryData locals =
    List.append entryData
        [ div
            [ style [ ( "width", "100px" ) ] ]
            [ text <| translateSpeciality locals <| doctor.speciality ]
        ]


withIsDistrictInfo nurse entryData districtNurse =
    List.append
        entryData
        [ div [ style [ ( "width", "100px" ) ] ]
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
        [ div [ style [ ( "width", "30%" ) ] ] [ text <| person.surname ++ " " ++ person.name ]
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
                        (onClick (PU.NewEntityUrl <| "/doctors/" ++ toString doctor.id))
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
                            (PU.NewEntityUrl <| "/nurses/" ++ toString nurse.id)
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
                    (onClick (PU.NewEntityUrl <| "/patients/" ++ toString patient.id))
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
        [ style [ ( "padding", "20px 160px" ), ( "background", "lightblue" ) ] ]
        (List.map
            (\staffMember ->
                div
                    [ style [ ( "display", "flex" ), ( "justify-content", "space-between" ) ] ]
                    [ p [ style Styles.button ] [ text <| staffMember.personal.name ++ " " ++ staffMember.personal.surname ]
                    , p [ style Styles.button ] [ text <| translate locals <| staffMember.who ]
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
    div [ style block ]
        [ people
        , newEntityBtn
        ]


newNurse newNurse =
    newEntity (onClick (PU.NewEntityUrl <| "/nurses/new")) newNurse


newDoctor newDoctor =
    newEntity (onClick (PU.NewEntityUrl <| "/doctors/new")) newDoctor


newNurseView locals =
    formToSubmit "nurses" <|
        List.concat
            [ newPersonFields locals
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text locals.districtNurse ]
                    , select [ name "district", style Styles.button ]
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
            , [ div [ style block, style blockCentered, style blockStretched ]
                    [ label [] [ text locals.speciality ]
                    , select [ required True, name "speciality", style Styles.button ]
                        (doctorSpecialities locals)
                    ]
              ]
            , [ submitBtn locals.add ]
            ]


submitBtn add =
    Html.button
        [ Html.Attributes.type_ "submit"
        , style Styles.button
        , style Styles.submit
        ]
        [ text add ]


createInput ( name_, label_, type_ ) =
    ( input
        [ required True
        , name name_
        , style Styles.button
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
    div [ style block, style blockCentered, style blockStretched ] inputWithLabel


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
        [ style Styles.form
        , Html.Attributes.action ("/api/" ++ endpoint)
        , Html.Attributes.method "POST"
        ]


newPatientView locals =
    formToSubmit "patients" <| List.concat [ newPersonFields locals, [ submitBtn locals.add ] ]


patientView patient locals =
    table [ personDetailsView ] (restTr patient locals)


rightAligned =
    style [ ( "text-align", "right" ) ]


recordStyle =
    style [ ( "padding", "10px" ) ]


restTr person locals =
    [ tr []
        [ td [ style Styles.button, recordStyle ]
            [ text <| locals.surname ]
        , td [ rightAligned, style Styles.button, recordStyle ]
            [ text person.personal.surname ]
        ]
    , tr []
        [ td [ style Styles.button, recordStyle ]
            [ text <| locals.name ]
        , td [ rightAligned, style Styles.button, recordStyle ]
            [ text person.personal.name ]
        ]
    , tr []
        [ td [ style Styles.button, recordStyle ]
            [ text <| locals.email ]
        , td [ rightAligned, style Styles.button, recordStyle ]
            [ text person.personal.email ]
        ]
    , tr []
        [ td [ style Styles.button, recordStyle ]
            [ text <| locals.id ]
        , td [ rightAligned, style Styles.button, recordStyle ]
            [ text <| toString <| person.id ]
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
        [ td [ style Styles.button ]
            [ text locals.speciality ]
        , td [ rightAligned, style Styles.button ]
            [ text <| translateSpeciality locals <| speciality ]
        ]


districtNurseTr isDistrict locals =
    tr []
        [ td [ style Styles.button ]
            [ text locals.districtNurse ]
        , td [ rightAligned, style Styles.button ]
            [ text <|
                if isDistrict then
                    locals.yes
                else
                    locals.no
            ]
        ]


personDetailsView =
    style [ ( "background", "lightblue" ), ( "border", "2px solid black" ) ]


doctorView doctor locals =
    table [ personDetailsView ] (List.concat [ restTr doctor locals, [ specialityTr doctor.speciality locals ] ])


nurseView nurse locals =
    table [ personDetailsView ] (List.concat [ restTr nurse locals, [ districtNurseTr nurse.district locals ] ])


nursesView nurses locals =
    view (newNurse locals.newNurse) (nursesList nurses locals)
