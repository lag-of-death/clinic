module People.Update exposing (..)

import People.Requests exposing (..)
import People.Types exposing (..)
import People.Helpers exposing (..)
import Navigation as Nav


updateNurses : NursesMsg -> List Nurse -> ( List Nurse, Cmd NursesMsg )
updateNurses msg model =
    case msg of
        NewNursesUrl url ->
            ( model, Nav.newUrl url )

        NurseDeleted _ ->
            ( model, getNurses )

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

        NurseData (Ok nurse) ->
            ( addPerson model nurse
            , Cmd.none
            )

        NurseData (Err err) ->
            let
                error =
                    Debug.log "NurseData error: " err
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

        DoctorData (Ok doctor) ->
            ( addPerson model doctor
            , Cmd.none
            )

        DoctorData (Err _) ->
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

        PatientData (Ok patient) ->
            ( addPerson model patient, Cmd.none )

        PatientData (Err err) ->
            let
                error =
                    Debug.log "PatientData error: " err
            in
                ( model, Cmd.none )
