//
//  ViewVideoController.swift
//  SocialApp
//
//  Created by Dmitry on 23.07.2020.
//  Copyright © 2020 Ifsoft. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewVideoController: UIViewController {
    
    @IBOutlet var videoView: UIView!
    
    var videoUrl = ""
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let url = URL(string:videoUrl)

        player = AVPlayer(url: url!)

        avpController.player = player

        avpController.view.frame.size.height = videoView.frame.size.height

        avpController.view.frame.size.width = videoView.frame.size.width

        self.videoView.addSubview(avpController.view)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
