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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "changeIcon"), style: .plain, target: self, action: #selector(swapCurrencies))
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        navigationItem.largeTitleDisplayMode = .never
        setupConstraints()
        createChildrenVC()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyBoardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyBoardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
    
    
    
    @objc private func swapCurrencies() {
        let settings = store.state.settings
        
        store.dispatch(SetSourceCurrencyAction(currency: settings.resultCurrency))
        store.dispatch(SetResultCurrencyAction(currency: settings.sourceCurrency))
        store.dispatch(CreateSetValuesAction(state: store.state, source: store.state.recognizing.sourceValue))
    }
    
    
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
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
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
            ])
    }
    
    
    private func createChildrenVC() {
        
        let guide = contentView.safeAreaLayoutGuide
        
        let cameraViewController = CameraViewController()
        addChildViewController(cameraViewController)
        let cameraView = cameraViewController.view!
        contentView.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cameraView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
            cameraView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
            cameraView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
            ])
        cameraViewController.didMove(toParentViewController: self)

        cameraViewController.connect(select: { state in state },
                                     isChanged: { _, _ in true },
                                     onChanged: { vc, state in
                                        let isManualEditing = state.recognizing.isManuallyEditing
                                        let status = isManualEditing ? .stopped : state.recognizing.recongnizingStatus

                                        vc.props = CameraViewController.Props(
                                            status: status,
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
        
        convertPanelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            convertPanelView.widthAnchor.constraint(equalToConstant: ConvertPanelView.width),
            convertPanelView.heightAnchor.constraint(equalToConstant: ConvertPanelView.height),
            convertPanelView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            convertPanelView.topAnchor.constraint(equalTo: cameraView.centerYAnchor, constant: CrossView.height / 2 + 10)
            ])
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


