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
    
    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: GameType)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension GameCommunicationManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("did receive invitation: \(peerId)")
    }
}
