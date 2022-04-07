//
//  MainViewController.swift
//  ColorPicker_Lesson_2.6
//
//  Created by Андрей Барсук on 07.04.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
  func updateColor(_ color: UIColor)
}

class MainViewController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let settingsVC = segue.destination as? SettingsViewController
    settingsVC?.mainViewColor = view.backgroundColor
    settingsVC?.delegate = self
  }
}

// MARK: Settings Delegate

extension MainViewController: SettingsViewControllerDelegate {
  func updateColor(_ color: UIColor) {
    view.backgroundColor = color
  }
}
