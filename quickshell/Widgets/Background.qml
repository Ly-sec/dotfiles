import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Settings

ShellRoot {
    property string wallpaperSource: WallpaperManager.currentWallpaper !== "" && !Settings.settings.useSWWW ? WallpaperManager.currentWallpaper : ""
    PanelWindow {
        visible: wallpaperSource !== ""
        anchors {
            bottom: true
            top: true
            right: true
            left: true
        }
        margins {
            top: 0
        }
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell-wallpaper"
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: wallpaperSource
            visible: wallpaperSource !== ""
            cache: true
            smooth: true
        }
    }
}