//
//  Constants.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 25.05.2023.
//

import Foundation

enum Constants {
    enum Text {
        static let firstOnboardingScreen = Bundle.main.localizedString(
            forKey: "Now all your documents is in one place",
            value: "",
            table: "Localizable"
        )
        static let secondOnboardingScreen = Bundle.main.localizedString(
            forKey: "Access to files without the Internet",
            value: "",
            table: "Localizable"
        )
        static let thirdOnboardingScreen = Bundle.main.localizedString(
            forKey: "Share your files with other people",
            value: "",
            table: "Localizable"
        )
        static let unknownItemName = Bundle.main.localizedString(
            forKey: "Unknown name",
            value: "",
            table: "Localizable"
        )
        static let unknownItemSize = Bundle.main.localizedString(
            forKey: "0 kb",
            value: "",
            table: "Localizable"
        )
        static let itemSize = Bundle.main.localizedString(
            forKey: " kb",
            value: "",
            table: "Localizable"
        )
        static let emptyDirectory = Bundle.main.localizedString(
            forKey: "The directory doesn't contain files",
            value: "",
            table: "Localizable"
        )
        static let refresh = Bundle.main.localizedString(
            forKey: "Refresh",
            value: "",
            table: "Localizable"
        )
        static let cancel = Bundle.main.localizedString(
            forKey: "Cancel",
            value: "",
            table: "Localizable"
        )
        static let deletePublication = Bundle.main.localizedString(
            forKey: "Delete publication",
            value: "",
            table: "Localizable"
        )
        static let profile = Bundle.main.localizedString(
            forKey: "Profile",
            value: "",
            table: "Localizable"
        )
        static let logOut = Bundle.main.localizedString(
            forKey: "Log Out",
            value: "",
            table: "Localizable"
        )
        static let exit = Bundle.main.localizedString(
            forKey: "Exit",
            value: "",
            table: "Localizable"
        )
        static let yes = Bundle.main.localizedString(
            forKey: "Yes",
            value: "",
            table: "Localizable"
        )
        static let no = Bundle.main.localizedString(
            forKey: "No",
            value: "",
            table: "Localizable"
        )
        static let confirmation = Bundle.main.localizedString(
            forKey: "Are you sure?",
            value: "",
            table: "Localizable"
        )
        static let totalSpace = Bundle.main.localizedString(
            forKey: " GB",
            value: "",
            table: "Localizable"
        )
        static let usedSpace = Bundle.main.localizedString(
            forKey: " GB - used",
            value: "",
            table: "Localizable"
        )
        static let availableSpace = Bundle.main.localizedString(
            forKey: " GB - available",
            value: "",
            table: "Localizable"
        )
        static let share = Bundle.main.localizedString(
            forKey: "Share this",
            value: "",
            table: "Localizable"
        )
        static let withFile = Bundle.main.localizedString(
            forKey: "File",
            value: "",
            table: "Localizable"
        )
        static let withLink = Bundle.main.localizedString(
            forKey: "Link",
            value: "",
            table: "Localizable"
        )
        static let delete = Bundle.main.localizedString(
            forKey: "Delete",
            value: "",
            table: "Localizable"
        )
        static let deleteAlert = Bundle.main.localizedString(
            forKey: "This file will be moved to the trash",
            value: "",
            table: "Localizable"
        )
        static let done = Bundle.main.localizedString(
            forKey: "Done",
            value: "",
            table: "Localizable"
        )
        static let placeholder = Bundle.main.localizedString(
            forKey: "Name",
            value: "",
            table: "Localizable"
        )
        static let rename = Bundle.main.localizedString(
            forKey: "Rename",
            value: "",
            table: "Localizable"
        )
    }
}
