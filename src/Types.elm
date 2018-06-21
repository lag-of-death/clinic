module Types
    exposing
        ( initialStyle
        , init
        , Model
        , Msg(..)
        , Flags
        )

import Localization.Types exposing (..)
import People.Update
import Modal.Update exposing (Msg)
import Navigation as Nav
import Animation
import Routes
import People.Types as PeopleTypes
import Modal.Types
import Visits.Types as VisitsTypes


initialStyle : Animation.State
initialStyle =
    Animation.style
        [ Animation.opacity 0.0
        ]


type alias Model =
    { history : List (Maybe Routes.Route)
    , style : Animation.State
    , patients : PeopleTypes.PatientsModel
    , doctors : PeopleTypes.DoctorsModel
    , nurses : PeopleTypes.NursesModel
    , visits : VisitsTypes.VisitsModel
    , newVisit : VisitsTypes.NewVisitModel
    , modal : Modal.Types.Modal Msg
    , showStaffList : Bool
    , staff : PeopleTypes.StaffModel
    , locals : Localization.Types.Locals
    , language : Localization.Types.Language
    , month : Int
    , currentMonth : Int
    }


type alias Flags =
    { month : Int
    }


init : Flags -> Nav.Location -> ( Model, Cmd Msg )
init a location =
    ( { history = []
      , style = initialStyle
      , patients = PeopleTypes.initialPatients
      , staff = []
      , doctors = PeopleTypes.initialDoctors
      , nurses = PeopleTypes.initialNurses
      , visits = VisitsTypes.initialVisits
      , newVisit = VisitsTypes.initialNewVisit
      , modal = Modal.Types.initialModel polishLocals.areYouSure NoOp
      , showStaffList = False
      , language = Localization.Types.PL
      , locals = Localization.Types.polishLocals
      , month = 0
      , currentMonth = a.month
      }
    , Nav.newUrl location.pathname
    )


type Msg
    = NewUrl String
    | PatientMsg (People.Update.Msg PeopleTypes.Patient)
    | StaffMsg (People.Update.Msg PeopleTypes.StaffMember)
    | DoctorMsg (People.Update.Msg PeopleTypes.Doctor)
    | NurseMsg (People.Update.Msg PeopleTypes.Nurse)
    | VisitMsg (People.Update.Msg VisitsTypes.Visit)
    | UrlChange Nav.Location
    | NewVisitMsg VisitsTypes.NewVisitMsg
    | ModalMsg (Modal.Update.Msg Msg)
    | NoOp
    | Animate Animation.Msg
    | Show
    | ShowStaffList
    | HideStaffList
    | ChangeLanguage Localization.Types.Language
