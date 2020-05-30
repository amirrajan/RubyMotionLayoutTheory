class MainView < UIViewController
  def rect_view_defaults
    {
      rect: nil,
      color: (UIColor.blackColor.colorWithAlphaComponent 1.0),
      __meta__: { rect: :CGRect, color: :UIColor }
    }
  end

  def new_rect_view opts
    opts = rect_view_defaults.merge opts
    view = UIView.alloc.initWithFrame opts[:rect].cg_rect
    view.layer.borderColor = opts[:color].CGColor
    view.layer.borderWidth = 1.0
    def view.pointInside point, withEvent: event
      false
    end
    view
  end

  def viewWillAppear animated
    puts "logical rect:  #{LayoutTheory.logical_rect}"
    puts "cell width:    #{LayoutTheory.cell_width.round}"
    puts "cell height:   #{LayoutTheory.cell_height.round}"
    puts "gutter width:  #{LayoutTheory.gutter_width.round}"
    puts "gutter height: #{LayoutTheory.gutter_height.round}"
    self.view.addSubview (new_rect_view rect: LayoutTheory.safe_area)
    LayoutTheory.row_count.times do |row|
      LayoutTheory.col_count.times do |col|
        self.view.addSubview (new_rect_view rect: (LayoutTheory.rect row: row, col: col))
      end
    end
  end
end

class AppDelegate
  def application application, didFinishLaunchingWithOptions: launchOptions
    rootViewController = MainView.alloc.init
    rootViewController.title = 'layout-theory'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)
    navigationController.navigationBar.hidden = true
    navigationController.navigationBar.setFrame CGRectMake(0, 0, 0, 0)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end

class TopLevel
  def reload

  end
end
