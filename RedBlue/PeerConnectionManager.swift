//
//  PeerConnectionManager.swift
//  RedBlue
//
//  Created by Scott Williams on 1/6/18.
//  Copyright © 2018 Scott Williams. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameCommunicationManager : NSObject {
    private let GameType = "redblue"
    
    private let peerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    var delegate: GameCommunicationManagerDelegate?
    
    lazy var session: MCSession = {
       let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: GameType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: GameType)
        super.init()
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendGameMessage(message: GameMessage) {
        print("sending message: \(message)")
        if session.connectedPeers.count > 0 {
            do {
                let data = message.rawValue.data(using: .utf8)!
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("error sending data: \(error.localizedDescription)")
            }
        } else {
            print("No connected peers")
        }
    }
}

enum GameMessage: String {
    case Start = "Start",
    End = "End"
}

protocol GameCommunicationManagerDelegate {
    func connectedDevicesChanged(manager: GameCommunicationManager, connectedDevices: [String])
    func messageReceived(manager: GameCommunicationManager, message: GameMessage)
}

extension GameCommunicationManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("did receive invitation: \(peerId)")
        invitationHandler(true, session)
    }
}

extension GameCommunicationManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer \(peerId)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("did not start browsing \(error.localizedDescription)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found peer \(peerId)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
}

extension GameCommunicationManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{ $0.displayName })
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        guard let s = String(data: data, encoding: .utf8),
              let message = GameMessage(rawValue: s) else { return }
        delegate?.messageReceived(manager: self, message: message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}
