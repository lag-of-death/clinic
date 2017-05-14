module Visits.Types exposing (..)

import Http exposing (..)


type VisitsMsg
    = DelVisit Int
    | VisitsData (Result Http.Error (List Visit))
    | VisitDeleted (Result Http.Error ())
    | NewVisitsUrl String


type alias Visit =
    { patient : Int
    , doctors : List Int
    , nurses : List Int
    , date : String
    , id : Int
    }


visits : List Visit
visits =
    [ { patient = 0
      , doctors = [ 0 ]
      , nurses = [ 0 ]
      , date = "12/08/2017"
      , id = 0
      }
    ]
