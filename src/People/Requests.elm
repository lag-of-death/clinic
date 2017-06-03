module People.Requests exposing (..)

import Http
import People.Types exposing (..)
import People.Decoders exposing (..)
import Requests exposing (..)


getPatients : Cmd PatientsMsg
getPatients =
    Http.send PatientsData (Http.get "/api/patients" decodePatients)


getPatient : Int -> Cmd PatientsMsg
getPatient id =
    Http.send PatientData (Http.get ("/api/patients/" ++ (toString id)) decodePatient)


getDoctors : Cmd DoctorsMsg
getDoctors =
    Http.send DoctorsData (Http.get ("/api/doctors") decodeDoctors)


getDoctor : Int -> Cmd DoctorsMsg
getDoctor id =
    Http.send DoctorData (Http.get ("/api/doctors/" ++ (toString id)) decodeDoctor)


getNurses : Cmd NursesMsg
getNurses =
    Http.send NursesData (Http.get ("/api/nurses") decodeNurses)


getNurse : Int -> Cmd NursesMsg
getNurse id =
    Http.send NurseData (Http.get ("/api/nurses/" ++ (toString id)) decodeNurse)


deleteDoctor : Int -> Cmd DoctorsMsg
deleteDoctor id =
    Http.send DoctorDeleted
        (delete "doctors" id)


deleteNurse : Int -> Cmd NursesMsg
deleteNurse id =
    Http.send NurseDeleted
        (delete "nurses" id)


deletePatient : Int -> Cmd PatientsMsg
deletePatient id =
    Http.send PatientDeleted
        (delete "patients" id)
