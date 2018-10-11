import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.2

ChangePinView {

    breadcrumbs: [{
            text: qsTr("PUK")
        }, {
            text: qsTr("Configure PINs")
        }, {
            text: qsTr("PUK")
        }]
    codeName: qsTr("PUK")
    defaultCurrentPin: '12345678'
    finishButtonTooltip: qsTr("Finish and change the PIV PUK")
    hasCurrentPin: true
    mainHeading: qsTr("Change PIV PUK")
    maxLength: constants.pivPukMaxLength
    minLength: constants.pivPukMinLength
    newPinTooltip: qsTr("The PIV PUK must be at least %1 characters").arg(
                       minLength)

    onChangePin: {
        yubiKey.piv_change_puk(currentPin, newPin, function (resp) {
            if (resp.success) {
                pivSuccessPopup.open()
                views.pop()
            } else {
                if (resp.tries_left < 1) {
                    pivError.show(qsTr("PUK is blocked."))
                    views.pop()
                } else {
                    pivError.show(
                                qsTr("PUK change failed. Tries remaining: %1").arg(
                                    resp.tries_left))
                }
            }
        })
    }

    onGoBack: views.pop()
}
