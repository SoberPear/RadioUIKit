//
//  JMainViewController.swift
//  J'Ma Radio
//
//  Created by Федор Рубченков on 15.02.2023.
//

import UIKit
import AVFoundation
import WebKit
import MediaPlayer

final class JMainViewController: UIViewController {
    
    enum Constants {
        static let buttonTitle: String = "J’ma products"
        static let trackName: String = "artist name - track 1"
        static let logoImageViewSize: CGSize = CGSize(width: 228, height: 92)
        static let textAttachmentInset: Float = 14
        static let musicURLString: String = "https://radiojma.hostingradio.ru/radiojma128.mp3"
    }
    
    private var isPlaying: Bool = false
    private lazy var audioPlayer: AVPlayer = {
        if let url = URL(string: Constants.musicURLString) {
            let playerItem = AVPlayerItem(url:  url)
            let audioPlayer = AVPlayer(playerItem: playerItem)
            return audioPlayer
        } else {
            return AVPlayer(playerItem: nil)
        }
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "logo_main_black")
        return imageView
    }()
    
    private lazy var pauseButton: JPauseButtonView = {
        JPauseButtonView(frame: .zero)
    }()
    
    private lazy var animationView: JAnimationView = {
        JAnimationView(frame: .zero)
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString()
        let image = UIImage(named: "ic_waves") ?? UIImage()
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: (UIFont.mainLightFont(size: 20).capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let stringWithAttachment = NSAttributedString(attachment: attachment)
        attributedString.append(stringWithAttachment)
        attributedString.append(NSAttributedString(string: " \(Constants.trackName)", attributes: [
            .font : UIFont.mainLightFont(size: 20),
            .foregroundColor : UIColor.j_textColor()//j_darkText()
        ]))
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.setTitleColor(.j_textColor(), for: .normal)
        button.setTitleColor(.j_white(), for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 235, height: 54)
        button.layer.cornerRadius = 29
        button.layer.borderColor = UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.backgroundColor = UIColor(red: 0.706, green: 0.596, blue: 0.412, alpha: 1).cgColor
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        view.addSubview(animationView)
        view.backgroundColor = .j_backgroundColor()
        containerView.addSubview(mainLogoImageView)
        containerView.addSubview(trackNameLabel)
        containerView.addSubview(pauseButton)
        view.addSubview(actionButton)
        view.addSubview(containerView)
        pauseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseButtonTapped)))
        containerView.alpha = 0.0
        actionButton.alpha = 0.0
        traitCollectionDidChange(traitCollection)
    }
    
    @objc func appMovedToBackground() {
        self.animationView.alpha = 0.0
        self.containerView.alpha = 1.0
        self.actionButton.alpha = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.startAnimation { [unowned self] in
            UIView.animate(withDuration: 0.3) {
                self.animationView.alpha = 0.0
                self.containerView.alpha = 1.0
                self.actionButton.alpha = 1.0
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        j_layout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
            mainLogoImageView.image = UIImage(named: "logo_main_black")
        } else {
            mainLogoImageView.image = UIImage(named: "logo_main_white")
        }
    }
    
}

private extension JMainViewController {
    
    func j_layout() {
        animationView.frame = view.bounds
        var containerViewHeight: CGFloat = 0.0
        containerViewHeight += mainLogoImageView.frame.height
        pauseButton.sizeToFit()
        containerViewHeight += Constants.logoImageViewSize.height
        let trackNameSize = trackNameLabel.sizeThatFits(CGSize(width: self.view.frame.width - 160, height: CGFloat.greatestFiniteMagnitude))
        containerViewHeight += max(trackNameSize.height, 21)
        containerViewHeight += 128 + 42
        containerViewHeight += pauseButton.bounds.height
        containerView.frame = CGRect(x: 0, y: self.view.frame.height / 844 * 126, width: view.frame.width, height: containerViewHeight)
        mainLogoImageView.frame = CGRect(x: (view.frame.width - Constants.logoImageViewSize.width)/2.0, y: 0, width: Constants.logoImageViewSize.width, height: Constants.logoImageViewSize.height)
        pauseButton.frame = CGRect(x: (view.frame.width - pauseButton.bounds.width) / 2.0, y: mainLogoImageView.frame.maxY + 128, width: pauseButton.bounds.width, height: pauseButton.bounds.height)
        trackNameLabel.frame = CGRect(x: (view.frame.width - trackNameSize.width)/2.0, y: pauseButton.frame.maxY + 42, width: trackNameSize.width, height: trackNameSize.height)
        let actionBUttonTitleSize = actionButton.titleLabel?.sizeThatFits(CGSize(width: view.frame.width - 120, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        actionButton.frame = CGRect(x: (view.frame.width - actionBUttonTitleSize.width - 100)/2.0, y: view.frame.height - 112 - 54, width: actionBUttonTitleSize.width + 100, height: 54)
    }
    
    @objc func actionButtonTapped() {
        let webViewController = JWebViewController(url: URL(string: "https://stolyarova.pro")!)
        present(webViewController, animated: true)
    }
    
    @objc func pauseButtonTapped() {
        isPlaying.toggle()
        pauseButton.show(isPlaying)
        play(isPlaying)
    }
    
    func play(_ start: Bool) {
        if start {
            audioPlayer.play()
            setupNowPlayingInfo()
        } else {
            audioPlayer.pause()
        }
    }
    
    func setupNowPlayingInfo() {
        let nowPlaying: [String: Any] = [
            MPMediaItemPropertyTitle: Constants.trackName,
            MPMediaItemPropertyArtist: "Sat Nam",
            MPNowPlayingInfoPropertyIsLiveStream: true
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.play(true)
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.play(false)
            return .success
        }
    }
    
}


