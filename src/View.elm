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


toBtnWithList : Bool -> Html Types.Msg
toBtnWithList showStaffList =
    div
        [ onMouseOver Types.ShowStaffList
        , onMouseLeave Types.HideStaffList
        , style [ ( "position", "relative" ) ]
        ]
        [ Html.button [ style Styles.button ]
            [ text "staff"
            ]
        , if showStaffList then
            ul
                [ style
                    [ ( "z-index", "1" )
                    , ( "position", "absolute" )
                    , ( "list-style-type", "none" )
                    , ( "top", "-2px" )
                    , ( "left", "-2px" )
                    , ( "padding", "0" )
                    , ( "margin", "0" )
                    ]
                ]
                [ li [] [ toBtn [ style Styles.button, style [ ( "width", "100%" ) ] ] "nurses" ]
                , li [] [ toBtn [ style Styles.button, style [ ( "width", "100%" ) ] ] "doctors" ]
                ]
          else
            span [] []
        ]


view : Types.Model -> Html Types.Msg
view model =
    Html.body [ style Styles.body ]
        [ div
            [ style Styles.menu ]
            [ toMenuBtn "patients"
            , toBtnWithList model.showStaffList
            , toMenuBtn "visits"
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
            "YES"
            model.modal
        ]


toBtn : List (Html.Attribute Types.Msg) -> String -> Html Types.Msg
toBtn styles whatAppPart =
    Html.button (List.concat [ styles, [ onClick (Types.NewUrl <| "/" ++ whatAppPart ++ "/") ] ]) [ text whatAppPart ]


toMenuBtn : String -> Html Types.Msg
toMenuBtn =
    toBtn [ style Styles.button ]


toRouteView : Types.Model -> Maybe Routes.Route -> Html Types.Msg
toRouteView model maybeRoute =
    case maybeRoute of
        Nothing ->
            div [ style [ ( "border", "2px solid red" ) ] ] [ text "no route matched" ]

        Just route ->
            case route of
                Routes.Visits ->
                    bordered <| Html.map Types.VisitMsg (VisitsView.view model.visits)

                Routes.VisitId id ->
                    centerElement <| Html.map Types.VisitMsg (VisitsView.visitView (getVisit id model.visits))

                Routes.NewVisit ->
                    centerElement <| Html.map Types.NewVisitMsg (VisitsView.newVisitView model)

                Routes.Patients ->
                    bordered <| Html.map Types.PatientMsg (PeopleView.patientsView model.patients)

                Routes.PatientId id ->
                    centerElement <| Html.map Types.PatientMsg (PeopleView.patientView (getPerson id model.patients PeopleTypes.defaultPatient))

                Routes.NewPatient ->
                    centerElement <| Html.map Types.PatientMsg PeopleView.newPatientView

                Routes.Doctors ->
                    bordered <| Html.map Types.DoctorMsg (PeopleView.doctorsView model.doctors)

                Routes.DoctorId id ->
                    centerElement <| Html.map Types.DoctorMsg (PeopleView.doctorView (getPerson id model.doctors PeopleTypes.defaultDoctor))

                Routes.NewDoctor ->
                    centerElement <| Html.map Types.DoctorMsg PeopleView.newDoctorView

                Routes.Nurses ->
                    bordered <| Html.map Types.NurseMsg (PeopleView.nursesView model.nurses)

                Routes.NurseId id ->
                    centerElement <| Html.map Types.NurseMsg (PeopleView.nurseView (getPerson id model.nurses PeopleTypes.defaultNurse))

                Routes.NewNurse ->
                    centerElement <| Html.map Types.NurseMsg PeopleView.newNurseView
