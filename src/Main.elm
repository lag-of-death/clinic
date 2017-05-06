module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style)
import Navigation as Nav
import UrlParser exposing (..)
import Home.Main as Home
import People.View as PeopleView
import People.Update as PeopleUpdate
import People.Types as PeopleTypes
import People.Http as PeopleHttp
import People.Helpers exposing (..)
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
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , patients = []
      , doctors = []
      , nurses = []
      }
    , Nav.newUrl location.pathname
    )



-- ROUTES


type Route
    = Home
    | PersonId Int
    | People
    | NewPerson
    | Doctors
    | DoctorId Int
    | Nurses
    | NurseId Int


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Nurses (UrlParser.s "nurses")
        , UrlParser.map NurseId (UrlParser.s "nurses" </> int)
        , UrlParser.map People (UrlParser.s "patients")
        , UrlParser.map Doctors (UrlParser.s "doctors")
        , UrlParser.map DoctorId (UrlParser.s "doctors" </> int)
        , UrlParser.map PersonId (UrlParser.s "patients" </> int)
        , UrlParser.map NewPerson (UrlParser.s "patients" </> UrlParser.s "new")
        ]



-- UPDATE


type Msg
    = NewUrl String
    | PeopleMsg ( String, PeopleTypes.Msg )
    | UrlChange Nav.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model
            , Nav.newUrl url
            )

        PeopleMsg ( whatPeople, peopleMsg ) ->
            case whatPeople of
                "patients" ->
                    let
                        ( peopleModel, peopleCmd ) =
                            PeopleUpdate.update peopleMsg model.patients
                    in
                        ( { model | patients = peopleModel }
                        , Cmd.map (\msg -> PeopleMsg ( whatPeople, msg )) peopleCmd
                        )

                "doctors" ->
                    let
                        ( peopleModel, peopleCmd ) =
                            PeopleUpdate.updateDoctors peopleMsg model.doctors
                    in
                        ( { model | doctors = peopleModel }
                        , Cmd.map (\msg -> PeopleMsg ( whatPeople, msg )) peopleCmd
                        )

                "nurses" ->
                    let
                        ( peopleModel, peopleCmd ) =
                            PeopleUpdate.updateNurses peopleMsg model.nurses
                    in
                        ( { model | nurses = peopleModel }
                        , Cmd.map (\msg -> PeopleMsg ( whatPeople, msg )) peopleCmd
                        )

                _ ->
                    ( model, Cmd.none )

        UrlChange location ->
            let
                maybeRoute =
                    UrlParser.parsePath routeParser location

                route =
                    Maybe.withDefault Home maybeRoute
            in
                ( { model | history = maybeRoute :: model.history }
                , case route of
                    People ->
                        Cmd.map (\x -> PeopleMsg ( "patients", x )) PeopleHttp.getPatients

                    PersonId _ ->
                        Cmd.map (\x -> PeopleMsg ( "patients", x )) PeopleHttp.getPatients

                    DoctorId _ ->
                        Cmd.map (\x -> PeopleMsg ( "doctors", x )) PeopleHttp.getDoctors

                    Doctors ->
                        Cmd.map (\x -> PeopleMsg ( "doctors", x )) PeopleHttp.getDoctors

                    Nurses ->
                        Cmd.map (\x -> PeopleMsg ( "nurses", x )) PeopleHttp.getNurses

                    NurseId _ ->
                        Cmd.map (\x -> PeopleMsg ( "nurses", x )) PeopleHttp.getNurses

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
            , Html.button [ style Styles.button, onClick (NewUrl "/nurses/") ] [ text "nurses" ]
            , Html.button [ style Styles.button, onClick (NewUrl "/doctors/") ] [ text "doctors" ]
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
                    Home ->
                        text Home.hello

                    People ->
                        Html.map (\a -> PeopleMsg ( "patients", a )) (PeopleView.patientsView model.patients)

                    NewPerson ->
                        Html.map (\a -> PeopleMsg ( "patients", a )) PeopleView.newPersonView

                    PersonId id ->
                        Html.map (\a -> PeopleMsg ( "patients", a )) (PeopleView.patientView (getPerson id model.patients defaultPatient))

                    Doctors ->
                        Html.map (\a -> PeopleMsg ( "doctors", a )) (PeopleView.doctorsView model.doctors)

                    DoctorId id ->
                        Html.map (\a -> PeopleMsg ( "doctors", a )) (PeopleView.doctorView (getPerson id model.doctors defaultDoctor))

                    NurseId id ->
                        Html.map (\a -> PeopleMsg ( "nurses", a )) (PeopleView.nurseView (getPerson id model.nurses defaultNurse))

                    Nurses ->
                        Html.text <| toString model.nurses
                ]
