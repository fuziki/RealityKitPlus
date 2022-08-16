//
//  ControllerView.swift
//  football
//  
//  Created by fuziki on 2022/08/16
//  
//

import Combine
import UIKit

class ControllerView: UIView {

    public private(set) var joyStick: SIMD2<Float> = .zero

    @IBOutlet weak var stick: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    private func setup() {
        loadFromNib()
        layer.cornerRadius = 64
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        addGestureRecognizer(gesture)
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "ControllerView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        v.frame = self.bounds
        addSubview(v)
    }

    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let r: CGFloat = 64
        var p: CGPoint
        if sender.state != .ended {
            p = sender.location(in: self)
            p.x -= r
            p.y -= r
            let l = sqrt(pow(p.x, 2) + pow(p.y, 2))
            if l > r {
                p.x *= 1 / l * r
                p.y *= 1 / l * r
            }
        } else {
            p = .zero
        }
        stick.transform.tx = p.x
        stick.transform.ty = p.y
        joyStick = .init(x: Float(p.x / r), y: Float(p.y / r))
    }
}
