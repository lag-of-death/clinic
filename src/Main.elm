module Main exposing (main)

import Html exposing (div, Html, main_, text)
import Html.Events exposing (onClick)
import Task
import Html.Attributes exposing (style)
import Navigation as Nav
import People.Views as PeopleView
import People.Update as PeopleUpdate
import People.Types as PeopleTypes
import People.Requests as PeopleHttp
import People.Helpers exposing (getPerson)
import Visits.Types as VisitsTypes exposing (NewVisitModel, VisitsMsg(DelVisit))
import Visits.Views as VisitsView
import Visits.Requests as VisitsHttp
import Visits.Update as VisitsUpdate
import Visits.Helpers exposing (getVisit)
import Styles
import Animation
import Routes
    exposing
        ( Route
            ( PatientId
            , Patients
            , NewPatient
            , Doctors
            , DoctorId
            , Nurses
            , NurseId
            , Visits
            , VisitId
            , NewVisit
            , NewNurse
            , NewDoctor
            )
        , parseRoute
        )
import Modal.Views
import Modal.Update exposing (Msg(Do, PrepareErr, Prepare, Hide))
import Modal.Types
import Views exposing (centerElement, bordered)


main : Program Never Model Msg
main =
    Nav.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]



-- MODEL


initialStyle : Animation.State
initialStyle =
    Animation.style
        [ Animation.opacity 0.0
        ]


type alias Model =
    { history : List (Maybe Route)
    , style : Animation.State
    , patients : PeopleTypes.PatientsModel
    , doctors : PeopleTypes.DoctorsModel
    , nurses : PeopleTypes.NursesModel
    , visits : VisitsTypes.VisitsModel
    , newVisit : NewVisitModel
    , modal : Modal.Types.Modal Msg
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , style = initialStyle
      , patients = PeopleTypes.initialPatients
      , doctors = PeopleTypes.initialDoctors
      , nurses = PeopleTypes.initialNurses
      , visits = VisitsTypes.initialVisits
      , newVisit = VisitsTypes.initialNewVisit
      , modal = Modal.Types.initialModel NoOp
      }
    , Nav.newUrl location.pathname
    )



-- UPDATE


show : Cmd Msg
show =
    Task.perform (\_ -> Show) <| Task.succeed ()


type Msg
    = NewUrl String
    | PatientsMsg PeopleTypes.PatientsMsg
    | NursesMsg PeopleTypes.NursesMsg
    | DoctorsMsg PeopleTypes.DoctorsMsg
    | UrlChange Nav.Location
    | VisitsMsg VisitsTypes.VisitsMsg
    | NewVisitMsg VisitsTypes.NewVisitMsg
    | ModalMsg (Modal.Update.Msg Msg)
    | NoOp
    | Animate Animation.Msg
    | Show


prepareModal : Model -> Modal.Update.Msg Msg -> ( Model, Cmd msg )
prepareModal model msg =
    let
        ( modalModel, _ ) =
            Modal.Update.update
                msg
                model.modal
                NoOp
    in
        ( { model | modal = modalModel }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate animMsg ->
            ( { model
                | style = Animation.update animMsg model.style
              }
            , Cmd.none
            )

        Show ->
            let
                newStyle =
                    Animation.interrupt
                        [ Animation.to
                            [ Animation.opacity 1.0
                            ]
                        ]
                        model.style
            in
                ( { model
                    | style = newStyle
                  }
                , Cmd.none
                )

        ModalMsg modalMsg ->
            let
                ( newModal, cmd ) =
                    Modal.Update.update modalMsg model.modal NoOp
            in
                ( { model | modal = newModal }, cmd )

        NewVisitMsg newVisitMsg ->
            let
                ( newVisit, cmd, _ ) =
                    VisitsUpdate.updateNewVisit newVisitMsg model.newVisit
            in
                ( { model | newVisit = newVisit }, Cmd.map NewVisitMsg cmd )

        VisitsMsg visitsMsg ->
            let
                ( visits, cmd, msgFromChild ) =
                    VisitsUpdate.updateVisits visitsMsg model.visits
            in
                case visitsMsg of
                    VisitsTypes.VisitDeleted (Err _) ->
                        prepareModal model PrepareErr

                    DelVisit _ ->
                        prepareModal model (Prepare <| ModalMsg <| Do <| VisitsMsg msgFromChild)

                    _ ->
                        ( { model | visits = visits }
                        , Cmd.batch [ show, Cmd.map VisitsMsg cmd ]
                        )

        NursesMsg nursesMsg ->
            let
                ( nurses, cmd, msgFromChild ) =
                    PeopleUpdate.updateNurses nursesMsg model.nurses
            in
                case nursesMsg of
                    PeopleTypes.NurseDeleted (Err _) ->
                        prepareModal model PrepareErr

                    PeopleTypes.DelNurse _ ->
                        prepareModal model (Prepare <| ModalMsg <| Do <| NursesMsg msgFromChild)

                    _ ->
                        ( { model | nurses = nurses }
                        , Cmd.batch [ show, Cmd.map NursesMsg cmd ]
                        )

        DoctorsMsg doctorsMsg ->
            let
                ( doctors, cmd, msgFromChild ) =
                    PeopleUpdate.updateDoctors doctorsMsg model.doctors
            in
                case doctorsMsg of
                    PeopleTypes.DoctorDeleted (Err _) ->
                        prepareModal model PrepareErr

                    PeopleTypes.DelDoctor _ ->
                        prepareModal model (Prepare <| ModalMsg <| Do <| DoctorsMsg msgFromChild)

                    _ ->
                        ( { model | doctors = doctors }
                        , Cmd.batch
                            [ show
                            , Cmd.map DoctorsMsg cmd
                            ]
                        )

        PatientsMsg patientsMsg ->
            let
                ( patients, peopleCmd, msgFromChild ) =
                    PeopleUpdate.updatePatients patientsMsg model.patients
            in
                case patientsMsg of
                    PeopleTypes.PatientDeleted (Err _) ->
                        prepareModal model PrepareErr

                    PeopleTypes.DelPatient _ ->
                        prepareModal model (Prepare <| ModalMsg <| Do <| PatientsMsg msgFromChild)

                    _ ->
                        ( { model | patients = patients }
                        , Cmd.batch [ show, Cmd.map PatientsMsg peopleCmd ]
                        )

        NewUrl url ->
            ( { model | style = initialStyle }
            , Cmd.batch [ Nav.newUrl url ]
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

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.body [ style Styles.body ]
        [ div
            [ style Styles.menu ]
            (List.map toMenuBtn [ "patients", "nurses", "doctors", "visits" ])
        , main_
            (List.concat
                [ [ style Styles.app ]
                , Animation.render model.style
                ]
            )
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Patients)
                |> toRouteView model
            ]
        , Modal.Views.view
            (ModalMsg Hide)
            "OK"
            model.modal.textMsg
            model.modal.shouldShow
            model.modal.msg
            model.modal.withActions
        ]


toMenuBtn : String -> Html Msg
toMenuBtn whatAppPart =
    Html.button [ style Styles.button, onClick (NewUrl <| "/" ++ whatAppPart ++ "/") ] [ text whatAppPart ]


toRouteView : Model -> Maybe Route -> Html Msg
toRouteView model maybeRoute =
    case maybeRoute of
        Nothing ->
            div [ style [ ( "border", "2px solid red" ) ] ] [ text "no route matched" ]

        Just route ->
            case route of
                Visits ->
                    bordered <| Html.map VisitsMsg (VisitsView.view model.visits)

                VisitId id ->
                    centerElement <| Html.map VisitsMsg (VisitsView.visitView (getVisit id model.visits))

                NewVisit ->
                    centerElement <| Html.map NewVisitMsg (VisitsView.newVisitView model.newVisit)

                Patients ->
                    bordered <| Html.map PatientsMsg (PeopleView.patientsView model.patients)

                PatientId id ->
                    centerElement <| Html.map PatientsMsg (PeopleView.patientView (getPerson id model.patients PeopleTypes.defaultPatient))

                NewPatient ->
                    centerElement <| Html.map PatientsMsg PeopleView.newPatientView

                Doctors ->
                    bordered <| Html.map DoctorsMsg (PeopleView.doctorsView model.doctors)

                DoctorId id ->
                    centerElement <| Html.map DoctorsMsg (PeopleView.doctorView (getPerson id model.doctors PeopleTypes.defaultDoctor))

                NewDoctor ->
                    centerElement <| Html.map DoctorsMsg PeopleView.newDoctorView

                Nurses ->
                    bordered <| Html.map NursesMsg (PeopleView.nursesView model.nurses)

                NurseId id ->
                    centerElement <| Html.map NursesMsg (PeopleView.nurseView (getPerson id model.nurses PeopleTypes.defaultNurse))

                NewNurse ->
                    centerElement <| Html.map NursesMsg PeopleView.newNurseView
