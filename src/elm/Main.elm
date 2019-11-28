module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, input, nav, span, text)
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
    , searchText : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        [ { id = "repositories", name = "Repositories", icon = "fa-archive", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        , { id = "items", name = "Items", icon = "fa-gears", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        , { id = "services", name = "Services", icon = "fa-gear", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        ]
        [ Course 1 "test" 100.0
        , Course 2 "test 2" 200.0
        , Course 3 "Essentials 2" 400.0
        ]
        Nothing
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
            case m of
                SearchInput input ->
                    ( { model | searchText = Just input }, Cmd.none )



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
    let
        courses =
            case model.searchText of
                Just filterText ->
                    List.filter (\x -> String.contains (String.toUpper filterText) (String.toUpper x.title)) model.courses

                Nothing ->
                    model.courses
    in
    div [ class "w-full" ]
        [ div [ class "flex" ]
            [ div [ class "flex-none w-64" ]
                [ Html.map SidebarMsg (sidebar model.sidebars)
                ]
            , div [ class "flex-grow" ]
                [ div [ class "flex-grow" ]
                    [ navbar
                    ]
                , div [ class "flex" ] (List.map viewCourse courses)
                ]
            ]
        ]


viewCourse : Course -> Html Msg
viewCourse course =
    div [ class "m-2 p-2 shadow" ]
        [ h1 [ class "text-xl font-semibold tracking-wide leading-loose" ] [ text (course.title ++ " Some") ]
        , div []
            [ span [ class "text-sm text-gray-800" ] [ text "Price:" ]
            , span [ class "font-semibold text-sm text-gray-800" ] [ text "100$" ]
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
