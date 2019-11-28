module Sidebar exposing (..)

import Html exposing (Html, a, aside, div, h1, i, li, span, text, ul)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)


type alias SidebarId =
    String


type alias SidebarItem =
    { name : String
    , link : String
    }


type alias SidebarModel =
    { id : SidebarId
    , name : String
    , items : List SidebarItem
    , collapsed : Bool
    }


type SidebarMsg
    = ToggleSidebar SidebarId


updateSidebar : SidebarMsg -> SidebarModel -> SidebarModel
updateSidebar msg model =
    case msg of
        ToggleSidebar index ->
            if index == model.id then
                { model | collapsed = not model.collapsed }

            else
                model


sidebar : List SidebarModel -> Html SidebarMsg
sidebar models =
    aside [ class "flex-none w-full h-full border-r shadow-lg h-screen bg-gray-800 " ]
        [ h1 [ class "h-24 text-white tracking-4 uppercase font-bold p-4 text-left text-middle leading-lg text-lg" ] [ text "Some academy" ]
        , div [] (List.map sidebarSection models)
        ]


sidebarSectionHeader : SidebarModel -> Html SidebarMsg
sidebarSectionHeader model =
    let
        chevronStyle =
            if model.collapsed then
                "flex-none fa fa-chevron-right"

            else
                "flex-none fa fa-chevron-down"
    in
    div [ class "flex items-center font-bold text-gray-500 uppercase pb-2 px-2 cursor-pointer", onClick <| ToggleSidebar model.id ]
        [ i [ class chevronStyle ] []
        , span [ class "flex-grow mx-2 select-none" ] [ text model.name ]
        , i [ class chevronStyle ] []
        ]


sidebarSectionItem : SidebarItem -> Html msg
sidebarSectionItem { name, link } =
    li []
        [ a [ class "block py-2 text-sm pl-5 text-gray-500 select-none hover:bg-gray-900 hover:shadow-lg hover:text-gray-300", href link ] [ text name ]
        ]


sidebarSection : SidebarModel -> Html SidebarMsg
sidebarSection model =
    div [ class "m-2 my-3" ]
        [ sidebarSectionHeader model
        , ul [ class "list-reset" ]
            (if model.collapsed then
                []

             else
                List.map sidebarSectionItem model.items
            )
        ]
