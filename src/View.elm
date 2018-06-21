module View exposing (view)

import Html exposing (div, main_, text, Html, span, ul, li)
import Animation
import Modal.Views
import Modal.Update exposing (Msg(Hide))
import Html.Events exposing (onClick, onMouseOver, onMouseLeave)
import People.Helpers exposing (getPerson)
import Visits.Helpers exposing (getVisit)
import Views exposing (centerElement, bordered)
import People.Views as PeopleView
import Visits.Views as VisitsView
import People.Types as PeopleTypes
import Html.Attributes exposing (style, class)
import Styles
import Routes
import Types
import Localization.Types as LT


toBtnWithList showStaffList locals =
    div
        [ onMouseOver Types.ShowStaffList
        , onMouseLeave Types.HideStaffList
        , style [ ( "position", "relative" ) ]
        ]
        [ Html.button [ style Styles.button ]
            [ text locals.staff
            ]
        , if showStaffList then
            ul
                [ style
                    [ ( "z-index", "1" )
                    , ( "position", "absolute" )
                    , ( "list-style-type", "none" )
                    , ( "top", "35px" )
                    , ( "left", "0px" )
                    , ( "padding", "0" )
                    , ( "margin", "0" )
                    ]
                ]
                [ li [] [ toBtn [ style Styles.button, style [ ( "width", "100%" ) ] ] "all" locals.all ]
                , li [] [ toBtn [ style Styles.button, style [ ( "width", "100%" ) ] ] "nurses" locals.nurses ]
                , li [] [ toBtn [ style Styles.button, style [ ( "width", "100%" ) ] ] "doctors" locals.doctors ]
                ]
          else
            span [] []
        ]


view : Types.Model -> Html Types.Msg
view model =
    div [ style Styles.body ]
        [ div
            [ style Styles.menu ]
            [ toMenuBtn "patients" model.locals.patients
            , toBtnWithList model.showStaffList model.locals
            , toMenuBtn "visits" model.locals.visits
            , div []
                [ Html.button
                    [ style Styles.button
                    , style [ ( "margin-right", "10px" ) ]
                    , if model.language == LT.EN then
                        style [ ( "color", "lightblue" ) ]
                      else
                        style []
                    , onClick (Types.ChangeLanguage LT.EN)
                    ]
                    [ text "EN" ]
                , Html.button
                    [ style Styles.button
                    , if model.language == LT.PL then
                        style [ ( "color", "lightblue" ) ]
                      else
                        style []
                    , onClick (Types.ChangeLanguage LT.PL)
                    ]
                    [ text "PL" ]
                ]
            ]
        , main_
            (List.concat
                [ [ style Styles.app ]
                , Animation.render model.style
                ]
            )
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Routes.Patients)
                |> toRouteView model
            ]
        , Modal.Views.view
            (Types.ModalMsg Hide)
            model.modal
            model.locals
        ]


toBtn : List (Html.Attribute Types.Msg) -> String -> String -> Html Types.Msg
toBtn styles whatAppPart label =
    Html.button (List.concat [ styles, [ onClick (Types.NewUrl <| "/" ++ whatAppPart ++ "/") ] ]) [ text label ]


toMenuBtn : String -> String -> Html Types.Msg
toMenuBtn =
    toBtn [ style Styles.button ]


toRouteView : Types.Model -> Maybe Routes.Route -> Html Types.Msg
toRouteView model maybeRoute =
    case maybeRoute of
        Nothing ->
            div [ style [ ( "border", "2px solid red" ) ] ] [ text "no route matched" ]

        Just route ->
            case route of
                Routes.AllStaff ->
                    bordered <| Html.map Types.StaffMsg (PeopleView.staffView model.staff model.locals)

                Routes.Visits ->
                    bordered <| Html.map Types.VisitMsg (VisitsView.view model.visits model.locals model.language)

                Routes.VisitId id ->
                    centerElement <| Html.map Types.VisitMsg (VisitsView.visitView (getVisit id model.visits) model.locals model.language)

                Routes.NewVisit ->
                    centerElement <| Html.map Types.NewVisitMsg (VisitsView.newVisitView model)

                Routes.Patients ->
                    bordered <| Html.map Types.PatientMsg (PeopleView.patientsView model.patients model.locals)

                Routes.PatientId id ->
                    centerElement <| Html.map Types.PatientMsg (PeopleView.patientView (getPerson id model.patients PeopleTypes.defaultPatient) model.locals)

                Routes.NewPatient ->
                    centerElement <| Html.map Types.PatientMsg (PeopleView.newPatientView model.locals)

                Routes.Doctors ->
                    bordered <| Html.map Types.DoctorMsg (PeopleView.doctorsView model.doctors model.locals)

                Routes.DoctorId id ->
                    centerElement <| Html.map Types.DoctorMsg (PeopleView.doctorView (getPerson id model.doctors PeopleTypes.defaultDoctor) model.locals)

                Routes.NewDoctor ->
                    centerElement <| Html.map Types.DoctorMsg (PeopleView.newDoctorView model.locals)

                Routes.Nurses ->
                    bordered <| Html.map Types.NurseMsg (PeopleView.nursesView model.nurses model.locals)

                Routes.NurseId id ->
                    centerElement <| Html.map Types.NurseMsg (PeopleView.nurseView (getPerson id model.nurses PeopleTypes.defaultNurse) model.locals)

                Routes.NewNurse ->
                    centerElement <| Html.map Types.NurseMsg (PeopleView.newNurseView model.locals)
