module People.Requests
    exposing
        ( deleteDoctor
        , getPatient
        , deletePatient
        , getPatients
        , getDoctors
        , getDoctor
        , getNurse
        , getNurses
        , deleteNurse
        )

import Http
import People.Types as PT
import People.Decoders as PD
import Requests exposing (delete)


getPatients : Cmd PT.PatientsMsg
getPatients =
    Http.send PT.PatientsData (Http.get "/api/patients" PD.decodePatients)


getPatient : Int -> Cmd PT.PatientsMsg
getPatient id =
    Http.send PT.PatientData (Http.get ("/api/patients/" ++ toString id) PD.decodePatient)


getDoctors : Cmd PT.DoctorsMsg
getDoctors =
    Http.send PT.DoctorsData (Http.get "/api/doctors" PD.decodeDoctors)


getDoctor : Int -> Cmd PT.DoctorsMsg
getDoctor id =
    Http.send PT.DoctorData (Http.get ("/api/doctors/" ++ toString id) PD.decodeDoctor)


getNurses : Cmd PT.NursesMsg
getNurses =
    Http.send PT.NursesData (Http.get "/api/nurses" PD.decodeNurses)


getNurse : Int -> Cmd PT.NursesMsg
getNurse id =
    Http.send PT.NurseData (Http.get ("/api/nurses/" ++ toString id) PD.decodeNurse)


deleteDoctor : Int -> Cmd PT.DoctorsMsg
deleteDoctor id =
    Http.send PT.DoctorDeleted
        (delete "doctors" id)


deleteNurse : Int -> Cmd PT.NursesMsg
deleteNurse id =
    Http.send PT.NurseDeleted
        (delete "nurses" id)


deletePatient : Int -> Cmd PT.PatientsMsg
deletePatient id =
    Http.send PT.PatientDeleted
        (delete "patients" id)
