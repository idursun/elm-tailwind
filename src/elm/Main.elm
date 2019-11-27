module Main exposing (..)

import Browser
import Html exposing (Html, div, input, nav, text)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onInput)
import Sidebar exposing (SidebarItem, SidebarModel, SidebarMsg, sidebar, updateSidebar)



---- MODEL ----


type alias Course =
    { id : Int
    , title : String
    , price : Float
    }


type alias Model =
    { sidebars : List SidebarModel
    , courses : List Course
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        [ SidebarModel "repositories" "Repositories" [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ] False
        , SidebarModel "items" "Items" [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ] False
        , SidebarModel "services " "Services" [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ] False
        ]
    , Cmd.none
    )



---- UPDATE ----


type NavbarMsg
    = SearchInput String


type Msg
    = SidebarMsg SidebarMsg
    | NavbarMsg NavbarMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SidebarMsg m ->
            ( { model | sidebars = List.map (updateSidebar m) model.sidebars }, Cmd.none )

        NavbarMsg m ->
            ( model, Cmd.none )



---- VIEW ----


navbar : Html Msg
navbar =
    nav [ class "flex justify-between items-center bg-white m-0 p-2 shadow-lg" ]
        [ div [ class "flex-initial w-1/2 mx-auto " ]
            [ input [ class "justify-center w-full border p-2 rounded", placeholder "Search courses", type_ "text", onInput (SearchInput >> NavbarMsg) ]
                []
            , text "  "
            ]
        , div [ class "flex items-center" ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ class "w-full" ]
        [ div [ class "flex" ]
            [ div [ class "flex-none w-64" ]
                [ Html.map SidebarMsg (sidebar model.sidebars)
                ]
            , div [ class "flex-grow" ]
                [ navbar
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
