internal import SwiftUI
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    var subject: String
    var messageBody: String
    var attachmentData: Data?
    var attachmentMimeType: String?
    var attachmentFileName: String?

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: false)
        if let attachmentData = attachmentData, let attachmentMimeType = attachmentMimeType, let attachmentFileName = attachmentFileName {
            vc.addAttachmentData(attachmentData, mimeType: attachmentMimeType, fileName: attachmentFileName)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeView

        init(_ parent: MailComposeView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            parent.isShowing = false
        }
    }
}
