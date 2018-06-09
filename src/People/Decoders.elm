module People.Decoders
    exposing
        ( decodeDoctor
        , decodeNurses
        , decodeDoctors
        , decodePatients
        , decodeNurse
        , decodePatient
        , decodeStaff
        )

import Json.Decode as Decode
import People.Types exposing (StaffMember, Person, Patient, Doctor, Nurse)


decodePerson : Decode.Decoder Person
decodePerson =
    Decode.map4 Person
        (Decode.field "name" Decode.string)
        (Decode.field "surname" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "id" Decode.int)


decodePatient : Decode.Decoder Patient
decodePatient =
    Decode.map2 Patient
        (Decode.field "personal" decodePerson)
        (Decode.field "id" Decode.int)


decodeStaffMember : Decode.Decoder StaffMember
decodeStaffMember =
    Decode.map3 StaffMember
        (Decode.field "personal" decodePerson)
        (Decode.field "id" Decode.int)
        (Decode.field "who" Decode.string)


decodeStaff : Decode.Decoder (List StaffMember)
decodeStaff =
    Decode.list decodeStaffMember


decodePatients : Decode.Decoder (List Patient)
decodePatients =
    Decode.list decodePatient


decodeDoctor : Decode.Decoder Doctor
decodeDoctor =
    Decode.map3 Doctor
        (Decode.field "personal" decodePerson)
        (Decode.field "speciality" Decode.string)
        (Decode.field "id" Decode.int)


decodeDoctors : Decode.Decoder (List Doctor)
decodeDoctors =
    Decode.list decodeDoctor


decodeNurse : Decode.Decoder Nurse
decodeNurse =
    Decode.map3 Nurse
        (Decode.field "personal" decodePerson)
        (Decode.field "district" Decode.bool)
        (Decode.field "id" Decode.int)


decodeNurses : Decode.Decoder (List Nurse)
decodeNurses =
    Decode.list decodeNurse
