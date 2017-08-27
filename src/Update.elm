module Update exposing (update)

import Task
import Types
import Visits.Decoders as VD
import Navigation as Nav
import Visits.Update as VisitsUpdate
import People.Helpers exposing (addPerson)
import Visits.Helpers exposing (addVisit)
import People.Requests
import Animation
import Routes exposing (Route(PatientId, Patients, Doctors, DoctorId, Nurses, NurseId, Visits, VisitId), parseRoute)
import Modal.Update exposing (Msg(Do, PrepareErr, Prepare))
import People.Update as PU
import People.Decoders as PD


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
                    Modal.Update.update modalMsg model.modal Types.NoOp
            in
                ( { model | modal = newModal }, cmd )

        Types.NewVisitMsg newVisitMsg ->
            let
                ( newVisit, cmd, _ ) =
                    VisitsUpdate.updateNewVisit newVisitMsg model.newVisit
            in
                ( { model | newVisit = newVisit }, Cmd.map Types.NewVisitMsg cmd )

        Types.NewUrl url ->
            ( { model | style = Types.initialStyle }
            , Cmd.batch [ Nav.newUrl url ]
            )

        Types.UrlChange location ->
            let
                maybeRoute =
                    parseRoute location

                route =
                    Maybe.withDefault Patients maybeRoute
            in
                ( { model | history = maybeRoute :: model.history }
                , case route of
                    Patients ->
                        Cmd.map Types.PatientMsg <| People.Requests.get "patients" PD.decodePatients PU.EntitiesData

                    PatientId id ->
                        Cmd.map Types.PatientMsg <| People.Requests.get ("patients/" ++ toString id) PD.decodePatient PU.EntityData

                    DoctorId id ->
                        Cmd.map Types.DoctorMsg <| People.Requests.get ("doctors/" ++ toString id) PD.decodeDoctor PU.EntityData

                    Doctors ->
                        Cmd.map Types.DoctorMsg <| People.Requests.get "doctors" PD.decodeDoctors PU.EntitiesData

                    Nurses ->
                        Cmd.map Types.NurseMsg <| People.Requests.get "nurses" PD.decodeNurses PU.EntitiesData

                    NurseId id ->
                        Cmd.map Types.NurseMsg <| People.Requests.get ("nurses/" ++ toString id) PD.decodeNurse PU.EntityData

                    Visits ->
                        Cmd.map Types.VisitMsg <| People.Requests.get "visits" VD.decodeVisits PU.EntitiesData

                    VisitId id ->
                        Cmd.map Types.VisitMsg <| People.Requests.get ("visits/" ++ toString id) VD.decodeVisits PU.EntitiesData

                    _ ->
                        Cmd.none
                )

        Types.VisitMsg innerMsg ->
            let
                ( visits, cmd, msgFromChild ) =
                    PU.updateEntity innerMsg model.visits "visits" VD.decodeVisits addVisit
            in
                handleMsg innerMsg model msgFromChild cmd { model | visits = visits } Types.VisitMsg

        Types.DoctorMsg innerMsg ->
            let
                ( doctors, cmd, msgFromChild ) =
                    PU.updateEntity innerMsg model.doctors "doctors" PD.decodeDoctors addPerson
            in
                handleMsg innerMsg model msgFromChild cmd { model | doctors = doctors } Types.DoctorMsg

        Types.NurseMsg innerMsg ->
            let
                ( nurses, cmd, msgFromChild ) =
                    PU.updateEntity innerMsg model.nurses "nurses" PD.decodeNurses addPerson
            in
                handleMsg innerMsg model msgFromChild cmd { model | nurses = nurses } Types.NurseMsg

        Types.PatientMsg innerMsg ->
            let
                ( patients, cmd, msgFromChild ) =
                    PU.updateEntity innerMsg model.patients "patients" PD.decodePatients addPerson
            in
                handleMsg innerMsg model msgFromChild cmd { model | patients = patients } Types.PatientMsg

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
            prepareModal model PrepareErr

        PU.DelEntity _ ->
            prepareModal model (Prepare <| Types.ModalMsg <| Do <| outerMsg msgFromChild)

        _ ->
            ( updatedModal
            , Cmd.batch [ show, Cmd.map outerMsg cmd ]
            )


prepareModal : Types.Model -> Modal.Update.Msg Types.Msg -> ( Types.Model, Cmd msg )
prepareModal model msg =
    let
        ( modalModel, _ ) =
            Modal.Update.update
                msg
                model.modal
                Types.NoOp
    in
        ( { model | modal = modalModel }
        , Cmd.none
        )