module People.Update exposing (..)

import People.Requests exposing (..)
import People.Types exposing (..)
import People.Helpers exposing (..)
import Navigation as Nav


updateNurses : NursesMsg -> List Nurse -> ( List Nurse, Cmd NursesMsg, NursesMsg )
updateNurses msg model =
    case msg of
        NoNursesOp ->
            ( model, Cmd.none, NoNursesOp )

        NewNursesUrl url ->
            ( model, Nav.newUrl url, NoNursesOp )

        NurseDeleted _ ->
            ( model, getNurses, NoNursesOp )

        NursesData (Ok nurses) ->
            ( nurses
            , Cmd.none
            , NoNursesOp
            )

        NursesData (Err err) ->
            let
                error =
                    Debug.log "NursesData error: " err
            in
                ( model, Cmd.none, NoNursesOp )

        NurseData (Ok nurse) ->
            ( addPerson model nurse
            , Cmd.none
            , NoNursesOp
            )

        NurseData (Err err) ->
            let
                error =
                    Debug.log "NurseData error: " err
            in
                ( model, Cmd.none, NoNursesOp )

        DelNurse id ->
            ( model, Cmd.none, ReallyDeleteNurse id )

        ReallyDeleteNurse id ->
            ( model, deleteNurse id, NoNursesOp )


updateDoctors : DoctorsMsg -> List Doctor -> ( List Doctor, Cmd DoctorsMsg, DoctorsMsg )
updateDoctors msg model =
    case msg of
        NoDoctorsOp ->
            ( model, Cmd.none, NoDoctorsOp )

        NewDoctorsUrl url ->
            ( model, Nav.newUrl url, NoDoctorsOp )

        DelDoctor id ->
            ( model, Cmd.none, ReallyDeleteDoctor id )

        ReallyDeleteDoctor id ->
            ( model, deleteDoctor id, NoDoctorsOp )

        DoctorDeleted _ ->
            ( model, getDoctors, NoDoctorsOp )

        DoctorsData (Ok doctors) ->
            ( doctors
            , Cmd.none
            , NoDoctorsOp
            )

        DoctorsData (Err _) ->
            ( model
            , Cmd.none
            , NoDoctorsOp
            )

        DoctorData (Ok doctor) ->
            ( addPerson model doctor
            , Cmd.none
            , NoDoctorsOp
            )

        DoctorData (Err _) ->
            ( model
            , Cmd.none
            , NoDoctorsOp
            )


updatePatients : PatientsMsg -> PatientsModel -> ( PatientsModel, Cmd PatientsMsg, PatientsMsg )
updatePatients msg model =
    case msg of
        NoPatientsOp ->
            ( model, Cmd.none, NoPatientsOp )

        NewPatientsUrl url ->
            ( model, Nav.newUrl url, NoPatientsOp )

        DelPatient id ->
            ( model, Cmd.none, ReallyDeletePatient id )

        ReallyDeletePatient id ->
            ( model, deletePatient id, NoPatientsOp )

        PatientDeleted _ ->
            ( model, getPatients, NoPatientsOp )

        PatientsData (Ok people) ->
            ( people, Cmd.none, NoPatientsOp )

        PatientsData (Err err) ->
            let
                error =
                    Debug.log "PeopleData error: " err
            in
                ( model, Cmd.none, NoPatientsOp )

        PatientData (Ok patient) ->
            ( addPerson model patient, Cmd.none, NoPatientsOp )

        PatientData (Err err) ->
            let
                error =
                    Debug.log "PatientData error: " err
            in
                ( model, Cmd.none, NoPatientsOp )
