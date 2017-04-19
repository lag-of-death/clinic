module Patients.Update exposing (..)

import Patients.Http exposing (..)
import Patients.Types exposing (..)
import Navigation as Nav


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Nav.newUrl url )

        GetPatients ->
            ( model, getPatients )

        PatientsData (Ok patients) ->
            ( patients, Cmd.none )

        PatientsData (Err err) ->
            let
                error =
                    Debug.log "PatientsData error: " err
            in
                ( model, Cmd.none )
