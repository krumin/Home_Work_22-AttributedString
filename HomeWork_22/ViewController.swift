//
//  ViewController.swift
//  HomeWork_22
//
//  Created by MAC OS  on 24.09.2019.
//  Copyright © 2019 MAC OS . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private enum Source {
    case camera
    case library
  }
  
  @IBOutlet weak var imageViewOne: UIImageView!
  @IBOutlet weak var imageViewTwo: UIImageView!
  @IBOutlet weak var imageViewThree: UIImageView!
  @IBOutlet weak var imageViewFour: UIImageView!
  
  
  @IBOutlet weak var labelOne: UILabel!
  @IBOutlet weak var labelTwo: UILabel!
  @IBOutlet weak var labelThree: UILabel!
  @IBOutlet weak var labelFour: UILabel!
  
  
  private var selectedTag: Int = 0
  
  private var imagePicker: UIImagePickerController?
  private lazy var views: [UIImageView] = [imageViewOne, imageViewTwo, imageViewThree, imageViewFour]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //весим UITapGestureRecognizer на view
    
    let tapViewOne = UITapGestureRecognizer(target: self, action: #selector(imageDidTap(sender:)))
    let tapViewTwo = UITapGestureRecognizer(target: self, action: #selector(imageDidTap(sender:)))
    let tapViewThree = UITapGestureRecognizer(target: self, action: #selector(imageDidTap(sender:)))
    let tapViewFour = UITapGestureRecognizer(target: self, action: #selector(imageDidTap(sender:)))
    
    imageViewOne.addGestureRecognizer(tapViewOne)
    imageViewTwo.addGestureRecognizer(tapViewTwo)
    imageViewThree.addGestureRecognizer(tapViewThree)
    imageViewFour.addGestureRecognizer(tapViewFour)
    
    prepareTextAttributed()
  }
  
  @objc func imageDidTap(sender: UITapGestureRecognizer) {
    showChoose { [weak self] source in
      guard let source = source else { return }
      
      let picker = UIImagePickerController()
      picker.delegate = self
      
      switch source {
      case .camera:
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
      case .library:
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
      }
      
      self?.present(picker, animated: true)
      self?.imagePicker = picker
    }
    selectedTag = sender.view?.tag ?? 0
    print(sender.view!.tag)
  }
  
  
  private func showChoose(choosen: @escaping (Source?) -> Void) {
    let alert = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
        choosen(.camera)
      })
    }
    alert.addAction(UIAlertAction(title: "Library", style: .default) { _ in
      choosen(.library)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
      choosen(nil)
    })
    
    present(alert, animated: true)
  }
  
  func createAttributedString(color: UIColor, text: String) -> NSAttributedString {
    
    let attributed: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 20),
      .foregroundColor: color,
      .kern: 1
    ]
    
    return NSAttributedString(string: text, attributes: attributed)
  }
  
  func prepareTextAttributed() {
    let attrStringOne = NSMutableAttributedString()
    let attrStringTwo = NSMutableAttributedString()
    let attrStringThree = NSMutableAttributedString()
    let attrStringFour = NSMutableAttributedString()
    
    let firstOneString = createAttributedString(color: .blue, text: "1")
    let firstTwoString = createAttributedString(color: .red, text: "2")
    let firstThreeString = createAttributedString(color: .green, text: "3")
    let firstFourString = createAttributedString(color: .brown, text: "4")
    
    let secondOneString = createAttributedString(color: .brown, text: "первый")
    let secondTwoString = createAttributedString(color: .green, text: "второй")
    let secondThreeString = createAttributedString(color: .red, text: "третий")
    let secondFourString = createAttributedString(color: .blue, text: "четвертый")
    
    attrStringOne.append(firstOneString)
    attrStringTwo.append(firstTwoString)
    attrStringThree.append(firstThreeString)
    attrStringFour.append(firstFourString)
    
    attrStringOne.append(secondOneString)
    attrStringTwo.append(secondTwoString)
    attrStringThree.append(secondThreeString)
    attrStringFour.append(secondFourString)
    
    labelOne.attributedText = attrStringOne
    labelTwo.attributedText = attrStringTwo
    labelThree.attributedText = attrStringThree
    labelFour.attributedText = attrStringFour
    
  }
  
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print("Image picked.")
    
    let image = info[.originalImage] as! UIImage
    let cropped = info[.editedImage] as! UIImage
    
    for imageView in views {
      if imageView.tag == selectedTag {
        imageView.image = cropped
        break
      }
    }
    
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("Cancel")
    picker.dismiss(animated: true)
  }
}
