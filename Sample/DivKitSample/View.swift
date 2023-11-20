import UIKit
import DivKit
import Serialization
import LayoutKit

class DivContaineer: UIView {
    
    var divView: DivView? = nil
    let components = DivKitComponents(
        trackVisibility: { _, _ in
            print(1)
        }, trackDisappear:{ _, _ in
            print(2)
        }, updateCardAction: { data in
            print(data)
        },
        
        urlOpener: {url in
            print(url)
        }
    )
    
    
    func updateWith(data: DivData?) {
        divView?.removeFromSuperview()
        divView = nil

        if let data = data {
            // card id (actually, an object id from Figma)
            let cardID = DivCardID(rawValue: data.logId)
            
            // load actual card data
            components.setVariablesAndTriggers(divData: data, cardId: cardID)
            
            let preloader = DivViewPreloader(divKitComponents: components)
            
//            components.urlHandler.handle(URL(string: "div-action://set_state?state_id=0/item1/second")!, sender: nil)
            // load template
            preloader.setSource(DivViewSource(kind: .divData(data), cardId: cardID))
            
            divView = DivView(divKitComponents: components, divViewPreloader: preloader)
            
            // make things doing
            divView?.showCardId(cardID)
            
            self.addSubview(divView!)
            divView?.backgroundColor = .white
            
            updateSizes()
        }
    }
    
    func updateSizes() {
        guard let divView = divView,
              let cardSize = divView.cardSize else {
            return
        }
        
        let size = cardSize.sizeFor(parentViewSize: bounds.size)
        
        let zoom: CGFloat
        if size.width != 0 {
            zoom = self.frame.width / size.width
        } else {
            zoom = 1
        }
        divView.layer.anchorPoint = .zero
        divView.transform = .init(scale: zoom)
        divView.bounds = CGRect(origin: .zero, size: size)
        //        self.contentSize = CGSize(width: self.frame.width, height: size.height * zoom)
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
}


extension DivContaineer: UIActionEventPerforming {
    func perform(uiActionEvent event: UIActionEvent, from _: AnyObject) {
//        print(event.payload.url, event.payload.debugDescription)
        switch event.payload {
        case let .divAction(params):
            components.actionHandler.handle(params: params, sender: nil)
        case .empty,
             .url,
             .menu,
             .json,
             .composite:
            break
        }
    }
}

