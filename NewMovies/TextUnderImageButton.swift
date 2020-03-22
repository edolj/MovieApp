//
//  TextUnderImageButton.swift
//  NewMovies
//
//  Created by Edo on 22/03/2020.
//  Copyright © 2020 Edo Ljubijankic. All rights reserved.
//

import UIKit

/// A button that displays an image centered above the title.  This implementation
/// only works when both an image and title are set, and ignores
/// any changes you make to edge insets.

@IBDesignable
class TextUnderImageButton: UIButton {
    @IBInspectable var spacing: CGFloat = 6.0
    
    override func layoutSubviews() {
        
        // lower the text and push it left so it appears centered
        //  below the image
        var titleEdgeInsets = UIEdgeInsets.zero
        if let image = self.imageView?.image {
            titleEdgeInsets.left = -image.size.width
            titleEdgeInsets.bottom = -(image.size.height + spacing)
        }
        self.titleEdgeInsets = titleEdgeInsets
        
        // raise the image and push it right so it appears centered
        //  above the text
        var imageEdgeInsets = UIEdgeInsets.zero
        if let text: String = self.titleLabel?.text, let font = self.titleLabel?.font {
            let attributes = [NSAttributedString.Key.font: font]
            let titleSize = text.size(withAttributes: attributes)
            imageEdgeInsets.top = -(titleSize.height + spacing)
            imageEdgeInsets.right = -titleSize.width
        }
        self.imageEdgeInsets = imageEdgeInsets
        
        super.layoutSubviews()
    }
}
