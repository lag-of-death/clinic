module People.Update exposing (updatePatients, updateDoctors, updateNurses)

import People.Requests exposing (getDoctors, deleteNurse, deleteDoctor, getPatients, deletePatient, getNurses)
import People.Types as PT
import People.Helpers exposing (addPerson)
import Navigation as Nav


updateNurses : PT.NursesMsg -> List PT.Nurse -> ( List PT.Nurse, Cmd PT.NursesMsg, PT.NursesMsg )
updateNurses msg model =
    case msg of
        PT.NoNursesOp ->
            ( model, Cmd.none, PT.NoNursesOp )

        PT.NewNursesUrl url ->
            ( model, Nav.newUrl url, PT.NoNursesOp )

        PT.NurseDeleted _ ->
            ( model, getNurses, PT.NoNursesOp )

        PT.NursesData (Ok nurses) ->
            ( nurses
            , Cmd.none
            , PT.NoNursesOp
            )

        PT.NursesData (Err _) ->
            ( model, Cmd.none, PT.NoNursesOp )

        PT.NurseData (Ok nurse) ->
            ( addPerson model nurse
            , Cmd.none
            , PT.NoNursesOp
            )

        PT.NurseData (Err _) ->
            ( model, Cmd.none, PT.NoNursesOp )

        PT.DelNurse id ->
            ( model, Cmd.none, PT.ReallyDeleteNurse id )

        PT.ReallyDeleteNurse id ->
            ( model, deleteNurse id, PT.NoNursesOp )


updateDoctors : PT.DoctorsMsg -> List PT.Doctor -> ( List PT.Doctor, Cmd PT.DoctorsMsg, PT.DoctorsMsg )
updateDoctors msg model =
    case msg of
        PT.NoDoctorsOp ->
            ( model, Cmd.none, PT.NoDoctorsOp )

        PT.NewDoctorsUrl url ->
            ( model, Nav.newUrl url, PT.NoDoctorsOp )

        PT.DelDoctor id ->
            ( model, Cmd.none, PT.ReallyDeleteDoctor id )

        PT.ReallyDeleteDoctor id ->
            ( model, deleteDoctor id, PT.NoDoctorsOp )

        PT.DoctorDeleted _ ->
            ( model, getDoctors, PT.NoDoctorsOp )

        PT.DoctorsData (Ok doctors) ->
            ( doctors
            , Cmd.none
            , PT.NoDoctorsOp
            )

        PT.DoctorsData (Err _) ->
            ( model
            , Cmd.none
            , PT.NoDoctorsOp
            )

        PT.DoctorData (Ok doctor) ->
            ( addPerson model doctor
            , Cmd.none
            , PT.NoDoctorsOp
            )

        PT.DoctorData (Err _) ->
            ( model
            , Cmd.none
            , PT.NoDoctorsOp
            )


updatePatients : PT.PatientsMsg -> PT.PatientsModel -> ( PT.PatientsModel, Cmd PT.PatientsMsg, PT.PatientsMsg )
updatePatients msg model =
    case msg of
        PT.NoPatientsOp ->
            ( model, Cmd.none, PT.NoPatientsOp )

        PT.NewPatientsUrl url ->
            ( model, Nav.newUrl url, PT.NoPatientsOp )

        PT.DelPatient id ->
            ( model, Cmd.none, PT.ReallyDeletePatient id )

        PT.ReallyDeletePatient id ->
            ( model, deletePatient id, PT.NoPatientsOp )

        PT.PatientDeleted _ ->
            ( model, getPatients, PT.NoPatientsOp )

        PT.PatientsData (Ok people) ->
            ( people, Cmd.none, PT.NoPatientsOp )

        PT.PatientsData (Err _) ->
            ( model, Cmd.none, PT.NoPatientsOp )

        PT.PatientData (Ok patient) ->
            ( addPerson model patient, Cmd.none, PT.NoPatientsOp )

        PT.PatientData (Err _) ->
            ( model, Cmd.none, PT.NoPatientsOp )
