module People.Decoders
    exposing
        ( decodeDoctor
        , decodeNurses
        , decodeDoctors
        , decodePatients
        , decodeNurse
        , decodePatient
        )

import Json.Decode as Decode
import People.Types exposing (Person, Patient, Doctor, Nurse)


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
        (Decode.field "personalData" decodePerson)
        (Decode.field "id" Decode.int)


decodePatients : Decode.Decoder (List Patient)
decodePatients =
    Decode.list decodePatient


decodeDoctor : Decode.Decoder Doctor
decodeDoctor =
    Decode.map3 Doctor
        (Decode.field "personalData" decodePerson)
        (Decode.field "speciality" Decode.string)
        (Decode.field "id" Decode.int)


decodeDoctors : Decode.Decoder (List Doctor)
decodeDoctors =
    Decode.list decodeDoctor


decodeNurse : Decode.Decoder Nurse
decodeNurse =
    Decode.map3 Nurse
        (Decode.field "personalData" decodePerson)
        (Decode.field "isDistrictNurse" Decode.bool)
        (Decode.field "id" Decode.int)


decodeNurses : Decode.Decoder (List Nurse)
decodeNurses =
    Decode.list decodeNurse
