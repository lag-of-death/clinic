module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style)
import Navigation as Nav
import UrlParser exposing (..)
import Home.Main as Home
import Patients.View as PatientsView
import Patients.Update as PatientsUpdate
import Patients.Types as PatientsTypes
import Patients.Http as PatientsHttp
import Patients.Helpers exposing (getPatient)
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
    , patients : List PatientsTypes.Patient
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , patients = []
      }
    , Nav.newUrl location.pathname
    )



-- ROUTES


type Route
    = Home
    | PatientId Int
    | Patients
    | NewPatient


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Patients (UrlParser.s "patients")
        , UrlParser.map PatientId (UrlParser.s "patients" </> int)
        , UrlParser.map NewPatient (UrlParser.s "patients" </> UrlParser.s "new")
        ]



-- UPDATE


type Msg
    = NewUrl String
    | PatientsMsg PatientsTypes.Msg
    | UrlChange Nav.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model
            , Nav.newUrl url
            )

        PatientsMsg patientsMsg ->
            let
                ( patientsModel, patientsCmd ) =
                    PatientsUpdate.update patientsMsg model.patients
            in
                ( { model | patients = patientsModel }
                , Cmd.map PatientsMsg patientsCmd
                )

        UrlChange location ->
            let
                maybeRoute =
                    UrlParser.parsePath routeParser location

                route =
                    Maybe.withDefault Home maybeRoute
            in
                ( { model | history = maybeRoute :: model.history }
                , case route of
                    Patients ->
                        Cmd.map PatientsMsg PatientsHttp.getPatients

                    PatientId _ ->
                        Cmd.map PatientsMsg PatientsHttp.getPatients

                    _ ->
                        Cmd.none
                )



-- VIEW


view : Model -> Html Msg
view model =
    Html.body [ style Styles.body ]
        [ div
            [ style Styles.menu ]
            [ Html.button [ style Styles.button, onClick (NewUrl "/") ] [ text "home" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/patients/") ] [ text "patients" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/404/") ] [ text "404" ]
            ]
        , main_ [ style Styles.app ]
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Home)
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
                    Patients ->
                        Html.map PatientsMsg (PatientsView.view model.patients)

                    Home ->
                        text Home.hello

                    NewPatient ->
                        Html.map PatientsMsg PatientsView.newPatientView

                    PatientId id ->
                        Html.map PatientsMsg (PatientsView.patientView (getPatient id model.patients))
                ]
