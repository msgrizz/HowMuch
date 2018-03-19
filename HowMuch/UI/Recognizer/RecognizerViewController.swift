//
//  CameraViewController.swift
//  Text Detection Starter Project
//
//  Created by Sai Kambampati on 6/21/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class RecognizerViewController: UIViewController {

    let debugCeilImageView = UIImageView(frame: CGRect.zero)
    let debugFloorImageView = UIImageView(frame: CGRect.zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "How much"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(openSettings))
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        navigationItem.largeTitleDisplayMode = .never
        setupConstraints()
        createChildrenVC()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyBoardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyBoardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
        // TODO Replace
        if checkHaveCameraAccess() {
            store.dispatch(SetRecognizingStatusAction(status: .running))
        } else {
            store.dispatch(SetRecognizingStatusAction(status: .noCameraAccess))
            requireCameraAccess()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: -Private
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    
    @objc private func openSettings() {
        let settingsVc = SettingViewController(style: .grouped)
        settingsVc.connect(to: store)
        navigationController?.pushViewController(settingsVc, animated: true)
    }
    
    
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
            ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalTo: guide.heightAnchor, constant: 0),
            ])
    }
    
    
    private func createChildrenVC() {
        let cameraViewController = CameraViewController()
        addChildViewController(cameraViewController)
        let cameraView = cameraViewController.view!
        contentView.addSubview(cameraView)
        
        cameraViewController.connect(select: { state in state },
                                     isChanged: { _, _ in true },
                                     onChanged: { vc, state in
                                        let status = state.recognizing.recongnizingStatus
                                        let isManualEditing = state.recognizing.isManuallyEditing
                                        
                                        vc.props = CameraViewController.Props(
                                            status: isManualEditing ? .stopped : state.recognizing.recongnizingStatus,
                                            tryParseFloat: state.settings.tryParseFloat,
                                            onTap: {
                                                switch status {
                                                case .suspended:
                                                    store.dispatch(SetRecognizingStatusAction(status: .running))
                                                case .running:
                                                    store.dispatch(SetRecognizingStatusAction(status: .suspended))
                                                default:
                                                    break
                                                }
                                        },
                                            onRecognized: { (value: Float) in
                                                store.dispatch(CreateSetValuesAction(state: state, source: value))
                                        },
                                            onWillAppear: {
                                                switch status {
                                                case .stopped:
                                                    store.dispatch(SetRecognizingStatusAction(status: .running))
                                                default:
                                                    break
                                                }
                                        },
                                            onWillDisappear: {
                                                switch status {
                                                case .running:
                                                    store.dispatch(SetRecognizingStatusAction(status: .stopped))
                                                default:
                                                    break
                                                }
                                        },
                                            showBanner: !state.purchaseState.isPurchased)
        })

        
        
        let convertPanelViewController = ConvertPanelViewController()
        addChildViewController(convertPanelViewController)
        let convertPanelView = convertPanelViewController.view!
        contentView.addSubview(convertPanelView)
        convertPanelViewController.connect(to: store)
        
        // set constraints
        let guide = contentView.safeAreaLayoutGuide
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
            cameraView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            cameraView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            cameraView.bottomAnchor.constraint(equalTo: convertPanelView.topAnchor, constant: 0),
            ])
        
        convertPanelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            convertPanelView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -8),
            convertPanelView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            convertPanelView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            convertPanelView.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        cameraViewController.didMove(toParentViewController: self)
        convertPanelViewController.didMove(toParentViewController: self)
    }
    
    
    
    @objc private func onKeyBoardWillShow(notification: Notification) {
        guard let info = notification.userInfo else { return }
        let height = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let opts = UIViewAnimationOptions(rawValue: curve << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: opts, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: height)
        })
    }
    
    
    
    @objc private func onKeyBoardWillHide(notification: Notification) {
        guard let info = notification.userInfo else { return }
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let opts = UIViewAnimationOptions(rawValue: curve << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: opts, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
    }
    
    
    
    private func checkHaveCameraAccess() -> Bool {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return cameraAuthorizationStatus == .authorized
    }
    
    
    private func requireCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            DispatchQueue.main.async {
                if granted {
                    store.dispatch(SetRecognizingStatusAction(status: .running))
                }
            }
        }
    }
}


