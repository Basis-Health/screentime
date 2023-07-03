//
//  ShieldConfigurationExtension.swift
//  Example Shield Configuration
//
//  Created by Michael Jajou on 7/1/23.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        let name = application.localizedDisplayName ?? "this"
        let configuration = ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor.blue.withAlphaComponent(0.37),
            title: .init(text: "Blocked by Basis", color: .white),
            subtitle: .init(text: "You cannot use \(name) because it is time to wind down.", color: .white),
            primaryButtonLabel: .init(text: "Got it", color: .black),
            primaryButtonBackgroundColor: .white
        )
        return configuration
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
