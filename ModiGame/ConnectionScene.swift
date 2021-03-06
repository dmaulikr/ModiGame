import Foundation
import SpriteKit

class ConnectionScene: SKScene {
    
    
    let startGamebutton = SKLabelNode(fontNamed: "Chalkduster")
    var buttonImage = SKSpriteNode(imageNamed: "Button")
    var textField: UITextField!
    var textFieldImage = SKSpriteNode(imageNamed: "TextField")
    var tableViewImage = SKSpriteNode(imageNamed: "TableViewBorder")
    var yourNameLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var peerOne = SKLabelNode(fontNamed: "Chalkduster")
    var peerTwo = SKLabelNode(fontNamed: "Chalkduster")
    var peerThree = SKLabelNode(fontNamed: "Chalkduster")
    var peerFour = SKLabelNode(fontNamed: "Chalkduster")
    var peerFive = SKLabelNode(fontNamed: "Chalkduster")
    var peerSix = SKLabelNode(fontNamed: "Chalkduster")
    var peerSeven = SKLabelNode(fontNamed: "Chalkduster")
    var peerLabels: [SKLabelNode] = []
    
    override func didMoveToView(view: SKView) {
        
        positionPeerLabels()
        
        let background = SKSpriteNode(imageNamed: "Felt")
        background.size = self.frame.size
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.zPosition = 0
        
        yourNameLabel.text = "Your name:"
        yourNameLabel.fontSize = 18
        yourNameLabel.position = CGPoint(x: frame.width * 0.15 + (yourNameLabel.frame.width / 2), y: frame.height * 0.8)
        yourNameLabel.zPosition = 10
        
        self.addChild(yourNameLabel)
        
        textField = UITextField(frame: CGRect(x: CGRectGetMaxX(yourNameLabel.frame) + 20, y: frame.height - yourNameLabel.position.y - 25, width: 400, height: 40))
        textField.placeholder = "Type your name here"
        textField.font = UIFont(name: "Chalkduster", size: 17)
        textField.textColor = UIColor.whiteColor()
        textField.delegate = self
        
        textFieldImage.centerRect = CGRectMake(8.5 / 240, 7.5 / 32, 223 / 240, 17 / 32)
        textFieldImage.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        textFieldImage.position = CGPoint(x: CGRectGetMaxX(yourNameLabel.frame) + 10, y: CGRectGetMidY(yourNameLabel.frame) - 2)
        textFieldImage.zPosition = 11
        textFieldImage.xScale = ((frame.width * 0.85) - CGRectGetMinX(textFieldImage.frame)) / textFieldImage.frame.width
        self.addChild(textFieldImage)
        
        tableViewImage.centerRect = CGRectMake(10 / 458, 9 / 150, 438 / 458, 132 / 150)
        tableViewImage.position = CGPoint(x: ((frame.width * 0.15) + (tableViewImage.frame.width / 2)), y: frame.height / 2)
        tableViewImage.xScale = (frame.width * 0.85 - CGRectGetMinX(tableViewImage.frame)) / tableViewImage.frame.width
        tableViewImage.position = CGPoint(x: ((frame.width * 0.15) + (tableViewImage.frame.width / 2)), y: frame.height / 2)
        tableViewImage.zPosition = 11
        self.addChild(tableViewImage)
        
        
        startGamebutton.position = CGPoint(x: frame.width / 2, y: CGRectGetMaxY(frame) / 8)
        startGamebutton.text = "Start Game"
        startGamebutton.fontSize = 18
        startGamebutton.zPosition = 11
        
        buttonImage.position = startGamebutton.position
        buttonImage.zPosition = 10
        buttonImage.centerRect = CGRectMake(17.0/62.0, 17.0/74.0, 28.0/62.0, 39.0/74.0);
        buttonImage.anchorPoint = CGPoint(x: 0.5, y: 0.3)
        buttonImage.xScale = startGamebutton.frame.width / buttonImage.frame.width + 1
        buttonImage.yScale = startGamebutton.frame.height / buttonImage.frame.height + 0.5
        print(startGamebutton.frame)
        
        self.addChild(background)
        self.addChild(startGamebutton)
        self.addChild(buttonImage)
        view.addSubview(textField)
        
        
    }
    
    func positionPeerLabels() {
        peerLabels = [peerOne, peerTwo, peerThree, peerFour, peerFive, peerSix, peerSeven]
        for label in peerLabels {
            tableViewImage.addChild(label)
            label.fontSize = 14
            label.text = "Not Connected"
        }
        peerOne.position = CGPoint(x: -(tableViewImage.frame.width / 4), y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 4))
        peerTwo.position = CGPoint(x: -(tableViewImage.frame.width / 4), y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 3))
        peerThree.position = CGPoint(x: -(tableViewImage.frame.width / 4), y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 2))
        peerFour.position = CGPoint(x: -(tableViewImage.frame.width / 4), y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5))
        peerFive.position = CGPoint(x: tableViewImage.frame.width / 4, y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 4))
        peerSix.position = CGPoint(x: tableViewImage.frame.width / 4, y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 3))
        peerSeven.position = CGPoint(x: tableViewImage.frame.width / 4, y: -(tableViewImage.frame.height / 2) + (tableViewImage.frame.height / 5 * 2))
    }
    
    func goToGameScene() {
        let skView = self.view! as SKView
        let scene = GameScene(fileNamed: "GameScene")
        skView.showsFPS = false
        skView.showsNodeCount = false
        scene?.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    func orderedPlayersString() -> String {
        GameStateSingleton.sharedInstance.orderedPlayers = []
        let me = GameStateSingleton.sharedInstance.bluetoothService.session.myPeerID
        var orderedPlayers: String = "peerOrder" + me.displayName + "."
        GameStateSingleton.sharedInstance.orderedPlayers.append(Player(name: me.displayName, peerID: me))
        for player in GameStateSingleton.sharedInstance.bluetoothService.session.connectedPeers {
            orderedPlayers += player.displayName + "."
            GameStateSingleton.sharedInstance.orderedPlayers.append(Player(name: player.displayName, peerID: player))
        }
        return orderedPlayers
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if CGRectContainsPoint(startGamebutton.frame, touch.locationInNode(self)) {
                buttonImage.texture = SKTexture(imageNamed: "ButtonPressed")
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if CGRectContainsPoint(startGamebutton.frame, touch.locationInNode(self)) {
                GameStateSingleton.sharedInstance.bluetoothService.sendData(orderedPlayersString())
                GameStateSingleton.sharedInstance.bluetoothService.sendData("currentDealer\(GameStateSingleton.sharedInstance.bluetoothService.session.myPeerID.displayName)")
                GameStateSingleton.sharedInstance.currentDealer = GameStateSingleton.sharedInstance.orderedPlayers[0]
                GameStateSingleton.sharedInstance.bluetoothService.sendData("gametime")
                self.goToGameScene()
            }
            buttonImage.texture = SKTexture(imageNamed: "Button")
        }
    }
    func initializeBluetooth(textField: UITextField) {
        if textField.text != nil {
            GameStateSingleton.sharedInstance.deviceName = textField.text!
        } else {
            GameStateSingleton.sharedInstance.deviceName = "Missing name"
        }
        textField.resignFirstResponder()
        let modiService = ModiBlueToothService()
        GameStateSingleton.sharedInstance.bluetoothService = modiService
        GameStateSingleton.sharedInstance.bluetoothService.connectionSceneDelegate = self
    }
}

extension ConnectionScene: ConnectionSceneDelegate {
    func connectedDevicesChanged(manager: ModiBlueToothService, connectedDevices: [String]) {
        
        for peerLabel in peerLabels {
            peerLabel.text = "Not Connected"
        }
        
        for peerIndex in 0 ..< GameStateSingleton.sharedInstance.bluetoothService.session.connectedPeers.count {
            self.peerLabels[peerIndex].text = GameStateSingleton.sharedInstance.bluetoothService.session.connectedPeers[peerIndex].displayName
        }
        
        GameStateSingleton.sharedInstance.playersDictionary = [:]
        
        let me = GameStateSingleton.sharedInstance.bluetoothService.session.myPeerID
        GameStateSingleton.sharedInstance.playersDictionary[me.displayName] = me
        
        for peer in GameStateSingleton.sharedInstance.bluetoothService.session.connectedPeers {
            GameStateSingleton.sharedInstance.playersDictionary[peer.displayName] = peer
        }
        
        

    }
    func gotoGame() {
        self.goToGameScene()
    }
    func recievedUniversalPeerOrderFromHost(peers: [String]) {
        for peer in peers {
            let peerID = GameStateSingleton.sharedInstance.playersDictionary[peer]
            GameStateSingleton.sharedInstance.orderedPlayers.append(Player(name: peer, peerID: peerID!))
        }
    }
}

extension ConnectionScene: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        GameStateSingleton.sharedInstance.bluetoothService = nil
        initializeBluetooth(textField)
        return true
    }
}