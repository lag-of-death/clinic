module People.Update exposing (..)

import People.Http exposing (..)
import People.Types exposing (..)
import Navigation as Nav


updateNurses : NursesMsg -> List Nurse -> ( List Nurse, Cmd NursesMsg )
updateNurses msg model =
    case msg of
        NewNursesUrl url ->
            ( model, Nav.newUrl url )

        NursesData (Ok nurses) ->
            ( nurses
            , Cmd.none
            )

        NurseDeleted _ ->
            ( model, getNurses )

        NursesData (Err err) ->
            let
                error =
                    Debug.log "NursesData error: " err
            in
                ( model, Cmd.none )

        DelNurse id ->
            ( model, deleteNurse id )


updateDoctors : DoctorsMsg -> List Doctor -> ( List Doctor, Cmd DoctorsMsg )
updateDoctors msg model =
    case msg of
        NewDoctorsUrl url ->
            ( model, Nav.newUrl url )

        DelDoctor id ->
            ( model, deleteDoctor id )

        DoctorDeleted _ ->
            ( model, getDoctors )

        DoctorsData (Ok doctors) ->
            ( doctors
            , Cmd.none
            )

        DoctorsData (Err _) ->
            ( model
            , Cmd.none
            )


updatePatients : PatientsMsg -> Model -> ( Model, Cmd PatientsMsg )
updatePatients msg model =
    case msg of
        NewPatientsUrl url ->
            ( model, Nav.newUrl url )

        DelPatient id ->
            ( model, deletePatient id )

        PatientDeleted _ ->
            ( model, getPatients )

        PatientsData (Ok people) ->
            ( people, Cmd.none )

        PatientsData (Err err) ->
            let
                error =
                    Debug.log "PeopleData error: " err
            in
                ( model, Cmd.none )
