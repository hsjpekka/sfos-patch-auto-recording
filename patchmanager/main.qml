import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    ConfigurationGroup {
        id: autoRecordSettings
        path: "/apps/patchmanager/auto-call-recording"
        property int  startDelay: 500
        property int  hangUpDelay: 1000
        property bool autoRecording: true
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator{}

        PullDownMenu {
            MenuItem {
                text: qsTr("reset delays")
                onClicked: {
                    startDelay.value = 0.5 // seconds
                    endDelay.value = 1.0 // seconds
                }
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: "Automatic call recording"
            }

            SectionHeader {
                text: qsTr("Description")
            }

            Label {
                text: qsTr("When an incoming or outgoing call is answered, this patch clicks the rec-button, unless recording is already started.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("Modifies CallingView.qml and InCallView.qml.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            SectionHeader {
                text: qsTr("settings")
            }

            TextSwitch {
                id: recording
                text: checked? qsTr("automatic recording") : qsTr("does not record automatically")
                checked: autoRecordSettings.autoRecording
                onClicked: {
                    autoRecordSettings.autoRecording = !autoRecordSettings.autoRecording
                }
            }

            DetailItem {
                label: qsTr("start delay")
                value: startDelay.value + " s"
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Slider {
                id: startDelay
                width: parent.width
                minimumValue: 0
                maximumValue: 2
                stepSize: 0.1
                value: autoRecordSettings.startDelay/1000
                onValueChanged: {
                    autoRecordSettings.startDelay = value*1000
                    autoRecordSettings.sync()
                }
            }

            DetailItem {
                label: qsTr("hang up delay")
                value: endDelay.value + " s"
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Slider {
                id: endDelay
                width: parent.width
                minimumValue: 0
                maximumValue: 2
                stepSize: 0.1
                value: autoRecordSettings.hangUpDelay/1000
                onValueChanged: {
                    autoRecordSettings.hangUpDelay = value*1000
                    autoRecordSettings.sync()
                }
            }

            SectionHeader {
                text: qsTr("Problems and my patches")
            }

            Label {
                text: qsTr("Tested with Xperia X, Nuuksio 3.2.1.20.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
                font.pixelSize: Theme.fontSizeExtraSmall
             }

            Label {
                text: qsTr("A short delay before the recording starts was added, because if recording an incoming call started immediatelly when callState became 'active', the recording was silent. 0.2 s was too short, so 0.5 s is used.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("A short delay was added to hanging up the call, because if telephony.hangupCall() was called immediatelly after emitting setAudioRecording(false), the following recordings were corrupted (the recording of a 20 s call was compressed to something like 3 s). 0.5 s was too short, so 1.0 s is used.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("Before I made the patch, I was able to corrupt future recordings by using two finger technique to end the call immediately after stopping the recording from the rec-button.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("If the other side hanged up when I was recording, the following recordings were corrupted. Emitting setAudioRecording(false) in onEndingCallChanged helped.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("A network error occured when a call was being recorded, and the following recordings were silent. It also resulted in two recordings: a good one and a few seconds long silent one. Didn't find out how to patch.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            TextField {
                text: qsTr("systemctl --user restart pulseaudio.service")
                color: Theme.secondaryColor//Theme.highlightColor
                width: parent.width - 2*x
                //x: Theme.horizontalPageMargin
                readOnly: true
                focusOnClick: true
            }

            Label {
                text: qsTr("Restarting pulseaudio should help to recover the quality in both cases - silent and corrupted recordings.")
                color: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

        }
    }

}
