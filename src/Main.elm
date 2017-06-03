module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style)
import Navigation as Nav
import People.View as PeopleView
import People.Update as PeopleUpdate
import People.Types as PeopleTypes
import People.Requests as PeopleHttp
import People.Helpers exposing (..)
import Visits.Types as VisitsTypes exposing (..)
import Visits.View as VisitsView
import Visits.Requests as VisitsHttp
import Visits.Update as VisitsUpdate
import Visits.Helpers exposing (..)
import Styles exposing (app, body, menu, button)
import Routes exposing (..)


main : Program Never Model Msg
main =
    Nav.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { history : List (Maybe Route)
    , patients : List PeopleTypes.Patient
    , doctors : List PeopleTypes.Doctor
    , nurses : List PeopleTypes.Nurse
    , visits : List Visit
    , newVisit : NewVisit
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , patients = []
      , doctors = []
      , nurses = []
      , visits = []
      , newVisit = VisitsTypes.newVisit
      }
    , Nav.newUrl location.pathname
    )



-- UPDATE


type Msg
    = NewUrl String
    | PatientsMsg PeopleTypes.PatientsMsg
    | NursesMsg PeopleTypes.NursesMsg
    | DoctorsMsg PeopleTypes.DoctorsMsg
    | UrlChange Nav.Location
    | VisitsMsg VisitsTypes.VisitsMsg
    | NewVisitMsg VisitsTypes.NewVisitMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewVisitMsg newVisitMsg ->
            let
                ( newVisit, cmd ) =
                    VisitsUpdate.updateNewVisit newVisitMsg model.newVisit
            in
                ( { model | newVisit = newVisit }, Cmd.map NewVisitMsg cmd )

        VisitsMsg visitsMsg ->
            let
                ( visits, cmd ) =
                    VisitsUpdate.updateVisits visitsMsg model.visits
            in
                ( { model | visits = visits }, Cmd.map VisitsMsg cmd )

        NursesMsg nursesMsg ->
            let
                ( nurses, cmd ) =
                    PeopleUpdate.updateNurses nursesMsg model.nurses
            in
                ( { model | nurses = nurses }, Cmd.map NursesMsg cmd )

        DoctorsMsg doctorsMsg ->
            let
                ( doctors, cmd ) =
                    PeopleUpdate.updateDoctors doctorsMsg model.doctors
            in
                ( { model | doctors = doctors }, Cmd.map DoctorsMsg cmd )

        PatientsMsg patientsMsg ->
            let
                ( patients, peopleCmd ) =
                    PeopleUpdate.updatePatients patientsMsg model.patients
            in
                ( { model | patients = patients }
                , Cmd.map PatientsMsg peopleCmd
                )

        NewUrl url ->
            ( model
            , Nav.newUrl url
            )

        UrlChange location ->
            let
                maybeRoute =
                    parseRoute location

                route =
                    Maybe.withDefault Patients maybeRoute
            in
                ( { model | history = maybeRoute :: model.history }
                , case route of
                    Patients ->
                        Cmd.map PatientsMsg PeopleHttp.getPatients

                    PatientId id ->
                        Cmd.map PatientsMsg (PeopleHttp.getPatient id)

                    DoctorId id ->
                        Cmd.map DoctorsMsg (PeopleHttp.getDoctor id)

                    Doctors ->
                        Cmd.map DoctorsMsg PeopleHttp.getDoctors

                    Nurses ->
                        Cmd.map NursesMsg PeopleHttp.getNurses

                    NurseId id ->
                        Cmd.map NursesMsg (PeopleHttp.getNurse id)

                    Visits ->
                        Cmd.map VisitsMsg VisitsHttp.getVisits

                    VisitId id ->
                        Cmd.map VisitsMsg (VisitsHttp.getVisit id)

                    _ ->
                        Cmd.none
                )



-- VIEW


view : Model -> Html Msg
view model =
    Html.body [ style Styles.body ]
        [ div
            [ style Styles.menu ]
            (List.map toMenuBtn [ "patients", "nurses", "doctors", "visits" ])
        , main_ [ style Styles.app ]
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Patients)
                |> toRouteView model
            ]
        ]


toMenuBtn : String -> Html Msg
toMenuBtn whatAppPart =
    Html.button [ style Styles.button, onClick (NewUrl <| "/" ++ whatAppPart ++ "/") ] [ text whatAppPart ]


toRouteView : Model -> Maybe Route -> Html Msg
toRouteView model maybeRoute =
    case maybeRoute of
        Nothing ->
            div [] [ text "no route matched" ]

        Just route ->
            div []
                [ case route of
                    Visits ->
                        Html.map VisitsMsg (VisitsView.view model.visits)

                    VisitId id ->
                        Html.map VisitsMsg (VisitsView.visitView (getVisit id model.visits))

                    NewVisit ->
                        Html.map NewVisitMsg (VisitsView.newVisitView model.newVisit)

                    Patients ->
                        Html.map PatientsMsg (PeopleView.patientsView model.patients)

                    PatientId id ->
                        Html.map PatientsMsg (PeopleView.patientView (getPerson id model.patients defaultPatient))

                    NewPatient ->
                        Html.map PatientsMsg PeopleView.newPatientView

                    Doctors ->
                        Html.map DoctorsMsg (PeopleView.doctorsView model.doctors)

                    DoctorId id ->
                        Html.map DoctorsMsg (PeopleView.doctorView (getPerson id model.doctors defaultDoctor))

                    NewDoctor ->
                        Html.map DoctorsMsg PeopleView.newDoctorView

                    Nurses ->
                        Html.map NursesMsg (PeopleView.nursesView model.nurses)

                    NurseId id ->
                        Html.map NursesMsg (PeopleView.nurseView (getPerson id model.nurses defaultNurse))

                    NewNurse ->
                        Html.map NursesMsg PeopleView.newNurseView
                ]
