module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style)
import Navigation as Nav
import UrlParser exposing (..)
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
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , patients = []
      , doctors = []
      , nurses = []
      , visits = []
      }
    , Nav.newUrl location.pathname
    )



-- ROUTES


type Route
    = PatientId Int
    | Patients
    | NewPatient
    | Doctors
    | DoctorId Int
    | Nurses
    | NurseId Int
    | Visits
    | VisitId Int
    | NewVisit
    | NewNurse
    | NewDoctor


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Patients top
        , UrlParser.map Visits (UrlParser.s "visits")
        , UrlParser.map Nurses (UrlParser.s "nurses")
        , UrlParser.map NurseId (UrlParser.s "nurses" </> int)
        , UrlParser.map NewNurse (UrlParser.s "nurses" </> UrlParser.s "new")
        , UrlParser.map Patients (UrlParser.s "patients")
        , UrlParser.map Doctors (UrlParser.s "doctors")
        , UrlParser.map DoctorId (UrlParser.s "doctors" </> int)
        , UrlParser.map VisitId (UrlParser.s "visits" </> int)
        , UrlParser.map NewVisit (UrlParser.s "visits" </> UrlParser.s "new")
        , UrlParser.map PatientId (UrlParser.s "patients" </> int)
        , UrlParser.map NewPatient (UrlParser.s "patients" </> UrlParser.s "new")
        , UrlParser.map NewDoctor (UrlParser.s "doctors" </> UrlParser.s "new")
        ]



-- UPDATE


type Msg
    = NewUrl String
    | PatientsMsg PeopleTypes.PatientsMsg
    | NursesMsg PeopleTypes.NursesMsg
    | DoctorsMsg PeopleTypes.DoctorsMsg
    | UrlChange Nav.Location
    | VisitsMsg VisitsTypes.VisitsMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                    UrlParser.parsePath routeParser location

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
            [ Html.button [ style Styles.button, onClick (NewUrl "/patients/") ] [ text "patients" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/nurses/") ] [ text "nurses" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/doctors/") ] [ text "doctors" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/visits/") ] [ text "visits" ]
            ]
        , main_ [ style Styles.app ]
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Patients)
                |> toRouteView model
            ]
        ]


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
                        Html.map VisitsMsg VisitsView.newVisitView

                    Patients ->
                        Html.map PatientsMsg (PeopleView.patientsView model.patients)

                    NewPatient ->
                        Html.map PatientsMsg PeopleView.newPatientView

                    PatientId id ->
                        Html.map PatientsMsg (PeopleView.patientView (getPerson id model.patients defaultPatient))

                    Doctors ->
                        Html.map DoctorsMsg (PeopleView.doctorsView model.doctors)

                    DoctorId id ->
                        Html.map DoctorsMsg (PeopleView.doctorView (getPerson id model.doctors defaultDoctor))

                    NewDoctor ->
                        Html.map DoctorsMsg PeopleView.newDoctorView

                    NurseId id ->
                        Html.map NursesMsg (PeopleView.nurseView (getPerson id model.nurses defaultNurse))

                    Nurses ->
                        Html.map NursesMsg (PeopleView.nursesView model.nurses)

                    NewNurse ->
                        Html.map NursesMsg PeopleView.newNurseView
                ]
