//
//  BezierCurvesViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/14.
//

import UIKit

// MARK: - BezierCurvesViewController

class BezierCurvesViewController: BaseViewController {
    private var contentView = BezierCurvesView()
    private var curveView: CurveView?
    private var points: [CGPoint] = []
    private var currentX: Int = 50
    private var currentY: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBarstyle(title: "Bezier Curves", titleColor: .white, backgroundColor: UIColor(named: "#0088CC"))

        setPoints()
        setupViews()
        drawCurveView(controlPoint: CGPoint(x: contentView.curvesView.bounds.width/2, y: contentView.curvesView.bounds.width/2))
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

// MARK: - Private Methods

private extension BezierCurvesViewController {
    func setupViews() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        
        contentView.xLeftButton.addTarget(self, action: #selector(xButtonAction(sender:)), for: .touchUpInside)
        contentView.xRightButton.addTarget(self, action: #selector(xButtonAction(sender:)), for: .touchUpInside)
        
        contentView.yUpButton.addTarget(self, action: #selector(yButtonAction(sender:)), for: .touchUpInside)
        contentView.yDownButton.addTarget(self, action: #selector(yButtonAction(sender:)), for: .touchUpInside)
    }

    func setPoints() {
        for i in 0 ..< 100 {
            points.append(CGPoint(x: i, y: i))
        }
    }
    
    @objc func xButtonAction(sender: UIButton) {
        let scale = contentView.curvesView.bounds.width / 100
        if sender == contentView.xLeftButton {
            if currentX-1 < 0 {
                currentX = 0
            } else {
                currentX -= 1
            }
        } else if sender == contentView.xRightButton {
            if currentX+1 > 99 {
                currentX = 99
            } else {
                currentX += 1
            }
        }
                    
        contentView.xValueLabel.text = String(format: "x:%d", currentX)
        contentView.yValueLabel.text = String(format: "y:%d", currentY)
        
        drawCurveView(controlPoint: CGPoint(x: CGFloat(currentX) * scale, y: CGFloat(currentY) * scale))
    }
    
    @objc func yButtonAction(sender: UIButton) {
        let scale = contentView.curvesView.bounds.height / 100
        
       
        if sender == contentView.yUpButton {
            if currentY+1 > 99 {
                currentY = 99
            } else {
                currentY += 1
            }
        } else if sender == contentView.yDownButton {
            if currentY-1 < 0 {
                currentY = 0
            } else {
                currentY -= 1
            }
        }
                    
        contentView.xValueLabel.text = String(format: "x:%d", currentX)
        contentView.yValueLabel.text = String(format: "y:%d", currentY)
        
        drawCurveView(controlPoint: CGPoint(x: CGFloat(currentX) * scale, y: CGFloat(currentY) * scale))
    }

    func drawCurveView(controlPoint: CGPoint) {
        if curveView != nil {
            curveView?.removeFromSuperview()
        }
        
        curveView = CurveView(frame: CGRect(x: 0, y: 0, width: contentView.curvesView.bounds.width, height: contentView.curvesView.bounds.height), controlPoint: controlPoint)
        contentView.curvesView.addSubview(curveView!)

        // 縮放比
        let scale = contentView.curvesView.bounds.width / 100

        // 將做表轉換為縮放前的值(預設0~99)
        guard let curveView = curveView else { return }
        points = curveView.getAllPoints().map { CGPoint(x: $0.x / scale, y: $0.y / scale) }
        //points.forEach { print("scaled point", $0)}
    }
}

import UIKit

// MARK: - CurveView

class CurveView: UIView {
    // MARK: - Private Properties

    var controlPoint: CGPoint = .zero

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, controlPoint: CGPoint) {
        super.init(frame: frame)
        self.controlPoint = controlPoint
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //MARK: - 翻轉y軸
        // 將原點移至左下角
        context.translateBy(x: 0, y: bounds.size.height)
        // 翻轉 y 軸，讓 y 軸正方向向上
        context.scaleBy(x: 1.0, y: -1.0)

        
        //MARK: - 格線
        let gridSize: CGFloat = bounds.size.width/10
        // 設定格線顏色與線寬（例如：淺灰色與 0.5）
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)

        // 畫垂直線
        for x in stride(from: 0, through: rect.width, by: gridSize) {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
        }

        // 畫水平線
        for y in stride(from: 0, through: rect.height, by: gridSize) {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }

        context.strokePath()

        //MARK: - 貝茲曲線
        // 定義三個點的座標
        let startPoint = CGPoint(x: 0, y: 0) // 起點
        // let controlPoint = CGPoint(x: bounds.size.width/2, y: 10)      // 控制點
        let endPoint = CGPoint(x: bounds.size.width, y: bounds.size.height) // 終點

        // 建立 UIBezierPath 並設定起點
        let bezierPath = UIBezierPath()
        bezierPath.move(to: startPoint)

        // 加入二次貝茲曲線
        bezierPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)

        // 設定曲線的外觀
        bezierPath.lineWidth = 3.0
        UIColor.red.setStroke()

        // 繪製曲線
        bezierPath.stroke()
    }

    /// 根據給定的 x 值，計算二次貝茲曲線上對應的 y 值。
    /// - Parameters:
    ///   - x: 給定的 x 值
    ///   - P0: 起點
    ///   - P1: 控制點
    ///   - P2: 終點
    /// - Returns: 對應的 y 值，如果找不到合適的 t 則返回 nil
    func yValue(forX x: CGFloat, P0: CGPoint, P1: CGPoint, P2: CGPoint) -> CGFloat? {
        // 計算二次方程式的係數
        let A = P0.x - 2 * P1.x + P2.x
        let B = -2 * P0.x + 2 * P1.x
        let C = P0.x - x

        var ts: [CGFloat] = []

        // 如果 A 很小，代表近似於一階方程式
        if abs(A) < CGFloat.ulpOfOne {
            if abs(B) < CGFloat.ulpOfOne {
                // 無法求解
                return nil
            }
            let t = -C / B
            ts.append(t)
        } else {
            // 計算判別式
            let discriminant = B * B - 4 * A * C
            if discriminant < 0 {
                // 沒有實數解
                return nil
            }
            let sqrtDiscriminant = sqrt(discriminant)
            let t1 = (-B + sqrtDiscriminant) / (2 * A)
            let t2 = (-B - sqrtDiscriminant) / (2 * A)
            ts.append(contentsOf: [t1, t2])
        }

        // 篩選 t 值必須在 [0, 1] 範圍內
        guard let t = ts.first(where: { $0 >= 0 && $0 <= 1 }) else {
            return nil
        }

        // 計算對應的 y 值
        let oneMinusT = 1 - t
        let y = oneMinusT * oneMinusT * P0.y + 2 * oneMinusT * t * P1.y + t * t * P2.y

        return y
    }

    func getAllPoints() -> [CGPoint] {
        let startPoint = CGPoint(x: 0, y: 0) // 起點
        let endPoint = CGPoint(x: bounds.size.width, y: bounds.size.height)
        var points = [CGPoint]()
        for i in 0 ..< 100 {
            let scale = bounds.width / 100.0
            let x = scale * CGFloat(i)
            if let y = yValue(forX: x, P0: startPoint, P1: controlPoint, P2: endPoint) {
                //print("對應的 x 值為 \(String(format: "%.2f", x))")
                //print("對應的 y 值為 \(String(format: "%.2f", y))\n")
                points.append(CGPoint(x: x, y: y))
            } else {
                // points.append(CGPoint(x: 0, y: 0))
                print("找不到對應的 y 值")
            }
        }

        return points
    }
}
