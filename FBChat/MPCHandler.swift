//
//  MPCManager.swift
//  FBChat
//
//  Created by e.a.morozova on 04.09.17.
//  Copyright © 2017 Катя. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {

    var session: MCSession!
    
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    
    var advertiser: MCAdvertiserAssistant!
    
    func setupPeerWith(displayName: String) {
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession() {
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "my-chat", session: session)
    }
    
    func advertiseSelf(_ advertise: Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-chat", discoveryInfo: nil, session: session)
            advertiser.start()
        } else {
            advertiser.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID": peerID, "state": state.rawValue] as [String: Any]
        DispatchQueue.main.async(execute: { () -> Void in NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["date": data, "peerID": peerID] as [String: Any]
        DispatchQueue.main.async(execute: { () -> Void in NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }

}
