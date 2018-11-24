module Update exposing (update)

import Animation
import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode as Decode
import Localization.Types as LT exposing (..)
import Modal.Update exposing (Msg(..))
import People.Decoders as PD
import People.Helpers exposing (addPerson)
import People.Requests
import People.Update as PU
import Routes exposing (Route(..), parseRoute)
import Task
import Time
import Types
import Visits.Decoders as VD
import Visits.Helpers exposing (addVisit)
import Visits.Types as VT
import Visits.Update as VisitsUpdate


update : Types.Msg -> Types.Model -> ( Types.Model, Cmd Types.Msg )
update msg model =
    case msg of
        Types.Animate animMsg ->
            ( { model
                | style = Animation.update animMsg model.style
              }
            , Cmd.none
            )

        Types.Show ->
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

        Types.ModalMsg modalMsg ->
            let
                ( newModal, cmd ) =
                    Modal.Update.update modalMsg model.modal Types.NoOp model.locals
            in
            ( { model | modal = newModal }, cmd )

        Types.NewUrl url ->
            ( { model | style = Types.initialStyle }
            , Nav.pushUrl model.key url
            )

        Types.NewVisitMsg newVisitMsg ->
            let
                ( newVisit, cmd ) =
                    VisitsUpdate.updateNewVisit newVisitMsg model.newVisit
            in
            case newVisitMsg of
                VT.NewVisitData (Ok _) ->
                    prepareModal model (ShowMsg model.locals.newVisitOk <| (doModalMsg <| Types.NewUrl "/visits"))

                VT.NewVisitData (Err result) ->
                    case result of
                        Http.BadStatus err ->
                            prepareModal model (ShowMsg model.locals.newVisitErr (Types.ModalMsg Hide))

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( { model | newVisit = newVisit }, Cmd.map Types.NewVisitMsg cmd )

        Types.UrlChange location ->
            let
                maybeRoute =
                    parseRoute location

                route =
                    Maybe.withDefault Patients maybeRoute

                newModel =
                    { model | history = maybeRoute :: model.history }

                cmds =
                    case route of
                        AllStaff ->
                            Cmd.map Types.StaffMsg <| People.Requests.get "staff" PD.decodeStaff PU.EntitiesData

                        Patients ->
                            Cmd.map Types.PatientMsg <| People.Requests.get "patients" PD.decodePatients PU.EntitiesData

                        PatientId id ->
                            Cmd.map Types.PatientMsg <| People.Requests.get ("patients/" ++ String.fromInt id) PD.decodePatient PU.EntityData

                        DoctorId id ->
                            Cmd.map Types.DoctorMsg <| People.Requests.get ("doctors/" ++ String.fromInt id) PD.decodeDoctor PU.EntityData

                        Doctors ->
                            Cmd.map Types.DoctorMsg <| People.Requests.get "doctors" PD.decodeDoctors PU.EntitiesData

                        Nurses ->
                            Cmd.map Types.NurseMsg <| People.Requests.get "nurses" PD.decodeNurses PU.EntitiesData

                        NurseId id ->
                            Cmd.map Types.NurseMsg <| People.Requests.get ("nurses/" ++ String.fromInt id) PD.decodeNurse PU.EntityData

                        Visits ->
                            Cmd.map Types.VisitMsg <| People.Requests.get "visits" VD.decodeVisits PU.EntitiesData

                        VisitId id ->
                            Cmd.map Types.VisitMsg <| People.Requests.get ("visits/" ++ String.fromInt id) VD.decodeVisit PU.EntityData

                        NewVisit ->
                            Cmd.batch
                                [ Cmd.map Types.PatientMsg <| People.Requests.get "patients" PD.decodePatients PU.EntitiesData
                                , Cmd.map Types.DoctorMsg <| People.Requests.get "doctors" PD.decodeDoctors PU.EntitiesData
                                , Cmd.map Types.NurseMsg <| People.Requests.get "nurses" PD.decodeNurses PU.EntitiesData
                                ]

                        _ ->
                            show
            in
            ( newModel, Cmd.batch [ cmds, Task.perform (\_ -> Types.ModalMsg Hide) <| Task.succeed () ] )

        Types.VisitMsg innerMsg ->
            let
                ( visits, cmd, msgFromChild ) =
                    PU.updateEntity model.key innerMsg model.visits "visits" VD.decodeVisits addVisit
            in
            handleMsg innerMsg model msgFromChild cmd { model | visits = visits } Types.VisitMsg

        Types.DoctorMsg innerMsg ->
            let
                ( doctors, cmd, msgFromChild ) =
                    PU.updateEntity model.key innerMsg model.doctors "doctors" PD.decodeDoctors addPerson
            in
            handleMsg innerMsg model msgFromChild cmd { model | doctors = doctors } Types.DoctorMsg

        Types.NurseMsg innerMsg ->
            let
                ( nurses, cmd, msgFromChild ) =
                    PU.updateEntity model.key innerMsg model.nurses "nurses" PD.decodeNurses addPerson
            in
            handleMsg innerMsg model msgFromChild cmd { model | nurses = nurses } Types.NurseMsg

        Types.PatientMsg innerMsg ->
            let
                ( patients, cmd, msgFromChild ) =
                    PU.updateEntity model.key innerMsg model.patients "patients" PD.decodePatients addPerson
            in
            handleMsg innerMsg model msgFromChild cmd { model | patients = patients } Types.PatientMsg

        Types.StaffMsg innerMsg ->
            let
                ( staff, cmd, msgFromChild ) =
                    PU.updateEntity model.key innerMsg model.staff "staff" PD.decodeStaff addPerson
            in
            ( { model | staff = staff }, show )

        Types.ShowStaffList ->
            ( { model | showStaffList = True }, Cmd.none )

        Types.HideStaffList ->
            ( { model | showStaffList = False }, Cmd.none )

        Types.ChangeLanguage lang ->
            case lang of
                LT.EN ->
                    ( { model | locals = LT.englishLocals, language = lang }, Cmd.none )

                LT.PL ->
                    ( { model | locals = LT.polishLocals, language = lang }, Cmd.none )

        _ ->
            ( model, Cmd.none )


show : Cmd Types.Msg
show =
    Task.perform (\_ -> Types.Show) <| Task.succeed ()


handleMsg :
    PU.Msg e
    -> Types.Model
    -> a
    -> Cmd a
    -> Types.Model
    -> (a -> Types.Msg)
    -> ( Types.Model, Cmd Types.Msg )
handleMsg innerMsg model msgFromChild cmd updatedModal outerMsg =
    case innerMsg of
        PU.EntityDeleted (Err _) ->
            prepareModal model (PrepareErr <| Types.ModalMsg <| Hide)

        PU.DelEntity _ ->
            prepareModal model (Prepare <| doModalMsg <| outerMsg msgFromChild)

        _ ->
            ( updatedModal
            , Cmd.batch [ show, Cmd.map outerMsg cmd ]
            )


doModalMsg : Types.Msg -> Types.Msg
doModalMsg =
    Do >> Types.ModalMsg


prepareModal : Types.Model -> Modal.Update.Msg Types.Msg -> ( Types.Model, Cmd msg )
prepareModal model msg =
    let
        ( modalModel, _ ) =
            Modal.Update.update
                msg
                model.modal
                Types.NoOp
                model.locals
    in
    ( { model | modal = modalModel }
    , Cmd.none
    )
