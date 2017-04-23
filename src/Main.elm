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
import People.Helpers exposing (getPerson)
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
    , patients : List PeopleTypes.Person
    , doctors : List PeopleTypes.Person
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = []
      , patients = []
      , doctors = []
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


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
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
            let
                ( peopleModel, peopleCmd ) =
                    PeopleUpdate.update whatPeople peopleMsg model.patients
            in
                case whatPeople of
                    "patients" ->
                        ( { model | patients = peopleModel }
                        , Cmd.map PeopleMsg (Cmd.map (\msg -> ( whatPeople, msg )) peopleCmd)
                        )

                    "doctors" ->
                        ( { model | doctors = peopleModel }
                        , Cmd.map PeopleMsg (Cmd.map (\msg -> ( whatPeople, msg )) peopleCmd)
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
                        Cmd.map PeopleMsg (Cmd.map (\x -> ( "patients", x )) (PeopleHttp.getPeople "patients"))

                    PersonId _ ->
                        Cmd.map PeopleMsg (Cmd.map (\x -> ( "patients", x )) (PeopleHttp.getPeople "patients"))

                    DoctorId _ ->
                        Cmd.map PeopleMsg (Cmd.map (\x -> ( "doctors", x )) (PeopleHttp.getPeople "doctors"))

                    Doctors ->
                        Cmd.map PeopleMsg (Cmd.map (\x -> ( "doctors", x )) (PeopleHttp.getPeople "doctors"))

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
                    People ->
                        Html.map PeopleMsg (Html.map (\msg -> ( "patients", msg )) (PeopleView.patientsView model.patients))

                    Doctors ->
                        Html.map PeopleMsg (Html.map (\msg -> ( "doctors", msg )) (PeopleView.peopleList "doctors" model.doctors))

                    DoctorId id ->
                        Html.map PeopleMsg (Html.map (\a -> ( "doctors", a )) (PeopleView.personView (getPerson id model.doctors)))

                    Home ->
                        text Home.hello

                    NewPerson ->
                        Html.map PeopleMsg (Html.map (\a -> ( "patients", a )) PeopleView.newPersonView)

                    PersonId id ->
                        Html.map PeopleMsg (Html.map (\a -> ( "patients", a )) (PeopleView.personView (getPerson id model.patients)))
                ]
