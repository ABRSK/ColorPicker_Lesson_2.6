//
//  SettingsViewController.swift
//  ColorPicker_Lesson_2.6
//
//  Created by Андрей Барсук on 07.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet var colorPreview: UIView!
  
  @IBOutlet var redColorLabel: UILabel!
  @IBOutlet var greenColorLabel: UILabel!
  @IBOutlet var blueColorLabel: UILabel!
  
  @IBOutlet var redColorSlider: UISlider!
  @IBOutlet var greenColorSlider: UISlider!
  @IBOutlet var blueColorSlider: UISlider!
  
  @IBOutlet var redColorTextField: UITextField!
  @IBOutlet var greenColorTextField: UITextField!
  @IBOutlet var blueColorTextField: UITextField!
  
  
  var mainViewColor: UIColor!
  var delegate: SettingsViewControllerDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
    updateSliders()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
  @IBAction func redColorSliderMoved() {
    setSliderLabelValues()
    setSliderTFValues()
    setColorPreview()
  }
  
  @IBAction func greenColorSliderMoved() {
    setSliderLabelValues()
    setSliderTFValues()
    setColorPreview()
  }
  
  @IBAction func blueColorSliderMoved() {
    setSliderLabelValues()
    setSliderTFValues()
    setColorPreview()
  }
  
  @IBAction func randomizeButtonPressed() {
    colorPreview.backgroundColor = UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1)
    
    updateSliders()
  }
  
  @IBAction func doneButtonPressed() {
    delegate.updateColor(colorPreview.backgroundColor ?? .white)
    dismiss(animated: true)
  }
  
  @IBAction func resetButtonPressed() {
    colorPreview.backgroundColor = UIColor(
      red: 1,
      green: 1,
      blue: 1,
      alpha: 1)
    
    updateSliders()
  }
}

// MARK: Private Methods

extension SettingsViewController {
  
  private func configUI() {
    colorPreview.backgroundColor = mainViewColor
    colorPreview.layer.cornerRadius = 8
    
    redColorSlider.maximumValue = 255
    redColorSlider.tintColor = .red.withAlphaComponent(0.5)
    redColorSlider.thumbTintColor = .red
    
    greenColorSlider.maximumValue = 255
    greenColorSlider.tintColor = .green.withAlphaComponent(0.5)
    greenColorSlider.thumbTintColor = .green
    
    blueColorSlider.maximumValue = 255
    blueColorSlider.tintColor = .blue.withAlphaComponent(0.5)
    blueColorSlider.thumbTintColor = .blue
    
  }
  
  private func updateSliders() {
    setSliderValues()
    setSliderLabelValues()
    setSliderTFValues()
  }
  
  private func setColorPreview() {
    colorPreview.backgroundColor = UIColor(
      red: CGFloat(redColorSlider.value) / 255,
      green: CGFloat(greenColorSlider.value) / 255,
      blue: CGFloat(blueColorSlider.value) / 255,
      alpha: 1)
  }
  
  private func setSliderValues() {
    let ciColor = CIColor(color: colorPreview.backgroundColor!)
    
    redColorSlider.setValue(Float(ciColor.red) * 255, animated: true)
    greenColorSlider.setValue(Float(ciColor.green) * 255, animated: true)
    blueColorSlider.setValue(Float(ciColor.blue) * 255, animated: true)
  }
  
  private func setSliderLabelValues() {
    redColorLabel.text = String(format: "%.0f", redColorSlider.value)
    greenColorLabel.text = String(format: "%.0f", greenColorSlider.value)
    blueColorLabel.text = String(format: "%.0f", blueColorSlider.value)
  }
  
  private func setSliderTFValues() {
    redColorTextField.text = String(format: "%.0f", redColorSlider.value)
    greenColorTextField.text = String(format: "%.0f", greenColorSlider.value)
    blueColorTextField.text = String(format: "%.0f", blueColorSlider.value)
  }
  
  @objc private func setSliderValuesFromTF() {
    guard let redTF = redColorTextField.text else { return }
    guard let greenTF = greenColorTextField.text else { return }
    guard let blueTF = blueColorTextField.text else { return }
    
    let values = [redTF, greenTF, blueTF]
    
    for value in values {
      if let floatValue = Float(value) {
        switch value {
        case redTF:
          redColorSlider.setValue(floatValue, animated: true)
        case greenTF:
          greenColorSlider.setValue(floatValue, animated:true)
        default:
          blueColorSlider.setValue(floatValue, animated: true)
        }
        
        setSliderLabelValues()
        setColorPreview()
        
      } else {
        showWrongFormatAlert()
      }
    }
    
    view.endEditing(true)
  }
  
  private func showWrongFormatAlert() {
    let alert = UIAlertController(title: "Something went wrong", message: "Text field is empty or wrong format is used! Please try again.", preferredStyle: .alert)
    let closeAction = UIAlertAction(title: "Close", style: .cancel)
    
    alert.addAction(closeAction)
    present(alert, animated: true)
  }
  
}

extension SettingsViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let bar = UIToolbar()
    let done = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(setSliderValuesFromTF)
    )
    let flex = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    bar.sizeToFit()
    textField.inputAccessoryView = bar
    bar.items = [flex, done]
    
    textField.selectAll(nil)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    setSliderValuesFromTF()
  }
  
}
