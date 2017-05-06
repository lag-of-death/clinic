module People.Update exposing (..)

import People.Http exposing (..)
import People.Types exposing (..)
import Navigation as Nav


updateNurses : Msg -> List Nurse -> ( List Nurse, Cmd Msg )
updateNurses msg model =
    case msg of
        NursesData (Ok nurses) ->
            ( nurses
            , Cmd.none
            )

        NursesData (Err err) ->
            let
                error =
                    Debug.log "NursesData error: " err
            in
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateDoctors : Msg -> List Doctor -> ( List Doctor, Cmd Msg )
updateDoctors msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        DelPerson id ->
            ( model, deleteDoctor id )

        DoctorDeleted _ ->
            ( model, getDoctors )

        DoctorsData (Ok doctors) ->
            ( doctors
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        DelPerson id ->
            ( model, deletePerson "patients" id )

        PersonDeleted _ ->
            ( model, getPatients )

        PatientsData (Ok people) ->
            ( people, Cmd.none )

        PatientsData (Err err) ->
            let
                error =
                    Debug.log "PeopleData error: " err
            in
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
