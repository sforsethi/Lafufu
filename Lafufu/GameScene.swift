import SpriteKit
import SwiftUI

enum TileType {
    case empty, wall, box, goal, player
}

class GameScene: SKScene {
    // Grid properties
    let gridWidth = 8
    let gridHeight = 10
    let tileSize: CGFloat = 64
    
    // Game state
    var gameGrid: [[TileType]] = []
    var playerPosition = (x: 1, y: 1)
    var boxes: [(x: Int, y: Int)] = []
    var goals: [(x: Int, y: Int)] = []
    
    // Sprite nodes
    var playerNode: SKSpriteNode!
    var boxNodes: [SKSpriteNode] = []
    var tileNodes: [[SKSpriteNode]] = []
    
    override func didMove(to view: SKView) {
        setupGame()
        setupLevel()
        renderLevel()
        setupGestures()
    }
    
    func setupGame() {
        backgroundColor = SKColor(red: 0.9, green: 0.9, blue: 0.85, alpha: 1.0)
        
        // Initialize grid
        gameGrid = Array(repeating: Array(repeating: .empty, count: gridWidth), count: gridHeight)
        tileNodes = Array(repeating: Array(repeating: SKSpriteNode(), count: gridWidth), count: gridHeight)
    }
    
    func setupLevel() {
        // Simple test level
        let levelData: [[Int]] = [
            [1,1,1,1,1,1,1,1],
            [1,0,0,0,0,0,0,1],
            [1,0,2,0,0,3,0,1],
            [1,0,0,0,0,0,0,1],
            [1,0,0,2,0,0,0,1],
            [1,0,0,0,0,0,0,1],
            [1,0,3,0,0,2,0,1],
            [1,0,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,1],
            [1,1,1,1,1,1,1,1]
        ]
        
        // Convert level data to game grid
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let tileValue = levelData[y][x]
                switch tileValue {
                case 0:
                    gameGrid[y][x] = .empty
                case 1:
                    gameGrid[y][x] = .wall
                case 2:
                    gameGrid[y][x] = .box
                    boxes.append((x: x, y: y))
                case 3:
                    gameGrid[y][x] = .goal
                    goals.append((x: x, y: y))
                default:
                    gameGrid[y][x] = .empty
                }
            }
        }
        
        // Set player position
        playerPosition = (x: 1, y: 1)
        gameGrid[playerPosition.y][playerPosition.x] = .player
    }
    
    func renderLevel() {
        removeAllChildren()
        boxNodes.removeAll()
        
        let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
        let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
        
        // Render tiles
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let posX = startX + CGFloat(x) * tileSize
                let posY = startY - CGFloat(y) * tileSize
                
                let tileType = gameGrid[y][x]
                let tileNode = createTileNode(for: tileType)
                tileNode.position = CGPoint(x: posX, y: posY)
                addChild(tileNode)
                tileNodes[y][x] = tileNode
                
                // Add box nodes separately for easier movement
                if tileType == .box {
                    let boxNode = createBoxNode()
                    boxNode.position = CGPoint(x: posX, y: posY)
                    addChild(boxNode)
                    boxNodes.append(boxNode)
                }
            }
        }
        
        // Render player
        let playerPosX = startX + CGFloat(playerPosition.x) * tileSize
        let playerPosY = startY - CGFloat(playerPosition.y) * tileSize
        playerNode = createPlayerNode()
        playerNode.position = CGPoint(x: playerPosX, y: playerPosY)
        addChild(playerNode)
    }
    
    func createTileNode(for tileType: TileType) -> SKSpriteNode {
        let node = SKSpriteNode(color: .clear, size: CGSize(width: tileSize, height: tileSize))
        
        switch tileType {
        case .empty:
            node.color = SKColor(red: 0.95, green: 0.95, blue: 0.9, alpha: 1.0)
        case .wall:
            node.color = SKColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1.0)
        case .goal:
            node.color = SKColor(red: 1.0, green: 0.9, blue: 0.5, alpha: 1.0)
            // Add a star pattern for goals
            let star = SKLabelNode(text: "⭐")
            star.fontSize = 48
            star.verticalAlignmentMode = .center
            star.horizontalAlignmentMode = .center
            node.addChild(star)
        case .box, .player:
            node.color = SKColor(red: 0.95, green: 0.95, blue: 0.9, alpha: 1.0)
        }
        
        return node
    }
    
    func createPlayerNode() -> SKSpriteNode {
        let node = SKSpriteNode(color: SKColor(red: 0.9, green: 0.6, blue: 0.8, alpha: 1.0), size: CGSize(width: tileSize * 0.9, height: tileSize * 0.9))
        
        // Add cute face - make it bigger and more visible
        let face = SKLabelNode(text: "🐰")
        face.fontSize = 48
        face.verticalAlignmentMode = .center
        face.horizontalAlignmentMode = .center
        node.addChild(face)
        
        return node
    }
    
    func createBoxNode() -> SKSpriteNode {
        let node = SKSpriteNode(color: SKColor(red: 0.8, green: 0.5, blue: 0.3, alpha: 1.0), size: CGSize(width: tileSize * 0.9, height: tileSize * 0.9))
        
        // Add box pattern - make it bigger and more visible
        let pattern = SKLabelNode(text: "📦")
        pattern.fontSize = 48
        pattern.verticalAlignmentMode = .center
        pattern.horizontalAlignmentMode = .center
        node.addChild(pattern)
        
        return node
    }
    
    func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var dx = 0, dy = 0
        
        switch gesture.direction {
        case .up:
            dy = -1
        case .down:
            dy = 1
        case .left:
            dx = -1
        case .right:
            dx = 1
        default:
            return
        }
        
        movePlayer(dx: dx, dy: dy)
    }
    
    func movePlayer(dx: Int, dy: Int) {
        let newX = playerPosition.x + dx
        let newY = playerPosition.y + dy
        
        // Check bounds
        guard newX >= 0 && newX < gridWidth && newY >= 0 && newY < gridHeight else { return }
        
        let targetTile = gameGrid[newY][newX]
        
        switch targetTile {
        case .wall:
            return // Can't move into wall
            
        case .empty, .goal:
            // Move player
            animatePlayerMove(to: (x: newX, y: newY))
            
        case .box:
            // Try to push box
            let boxNewX = newX + dx
            let boxNewY = newY + dy
            
            // Check if box can be pushed
            guard boxNewX >= 0 && boxNewX < gridWidth && boxNewY >= 0 && boxNewY < gridHeight else { return }
            
            let boxTargetTile = gameGrid[boxNewY][boxNewX]
            if boxTargetTile == .empty || boxTargetTile == .goal {
                // Push box
                gameGrid[newY][newX] = .empty
                gameGrid[boxNewY][boxNewX] = .box
                
                // Update box position in array
                if let boxIndex = boxes.firstIndex(where: { $0.x == newX && $0.y == newY }) {
                    boxes[boxIndex] = (x: boxNewX, y: boxNewY)
                }
                
                // Animate box movement
                animateBoxMove(from: (x: newX, y: newY), to: (x: boxNewX, y: boxNewY))
                
                // Move player
                animatePlayerMove(to: (x: newX, y: newY))
                
                // Check win condition
                checkWinCondition()
            }
            
        case .player:
            break // Should not happen
        }
    }
    
    func animatePlayerMove(to newPosition: (x: Int, y: Int)) {
        playerPosition = newPosition
        
        let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
        let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
        
        let newPosX = startX + CGFloat(newPosition.x) * tileSize
        let newPosY = startY - CGFloat(newPosition.y) * tileSize
        
        let moveAction = SKAction.move(to: CGPoint(x: newPosX, y: newPosY), duration: 0.2)
        moveAction.timingMode = .easeInEaseOut
        playerNode.run(moveAction)
    }
    
    func animateBoxMove(from oldPosition: (x: Int, y: Int), to newPosition: (x: Int, y: Int)) {
        // Find the box node at the old position
        if let boxNode = boxNodes.first(where: { node in
            let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
            let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
            let expectedX = startX + CGFloat(oldPosition.x) * tileSize
            let expectedY = startY - CGFloat(oldPosition.y) * tileSize
            return abs(node.position.x - expectedX) < 1 && abs(node.position.y - expectedY) < 1
        }) {
            let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
            let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
            
            let newPosX = startX + CGFloat(newPosition.x) * tileSize
            let newPosY = startY - CGFloat(newPosition.y) * tileSize
            
            let moveAction = SKAction.move(to: CGPoint(x: newPosX, y: newPosY), duration: 0.2)
            moveAction.timingMode = .easeInEaseOut
            boxNode.run(moveAction)
        }
    }
    
    func checkWinCondition() {
        let allBoxesOnGoals = boxes.allSatisfy { box in
            goals.contains { goal in
                goal.x == box.x && goal.y == box.y
            }
        }
        
        if allBoxesOnGoals {
            showWinMessage()
        }
    }
    
    func showWinMessage() {
        let winLabel = SKLabelNode(text: "🎉 Labubu Escaped! 🎉")
        winLabel.fontSize = 32
        winLabel.fontColor = .systemGreen
        winLabel.position = CGPoint(x: 0, y: 100)
        addChild(winLabel)
        
        // Add confetti effect
        let confetti = SKEmitterNode(fileNamed: "Confetti") ?? SKEmitterNode()
        confetti.position = CGPoint(x: 0, y: 200)
        addChild(confetti)
        
        // Auto-hide after 3 seconds
        let hideAction = SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.removeFromParent()
        ])
        winLabel.run(hideAction)
        confetti.run(hideAction)
    }
}

// Extension for corner radius on SKSpriteNode
extension SKSpriteNode {
    var cornerRadius: CGFloat {
        get { return 0 }
        set {
            let path = CGPath(roundedRect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height), cornerWidth: newValue, cornerHeight: newValue, transform: nil)
            let shape = SKShapeNode(path: path)
            shape.fillColor = color
            shape.strokeColor = .clear
            
            // Create texture from shape node
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { context in
                let cgContext = context.cgContext
                cgContext.setFillColor(color.cgColor)
                cgContext.addPath(path)
                cgContext.fillPath()
            }
            texture = SKTexture(image: image)
        }
    }
}
