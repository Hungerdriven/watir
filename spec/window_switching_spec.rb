require File.expand_path('watirspec/spec_helper', File.dirname(__FILE__))


describe Watir::Browser do

  before do
    url = "file://" + File.expand_path("html/window_switching.html", File.dirname(__FILE__))
    browser.goto url
    browser.a(:id => "open").click
  end

  after do
    win = browser.window(:title => "closeable window")
    win && win.close
  end

  describe "#windows" do
    it "returns an array of window handles" do
      wins = browser.windows
      wins.should_not be_empty
      wins.each { |win| win.should be_kind_of(Watir::Window) }
    end

    it "only returns windows matching the given selector" do
      browser.windows(:title => "closeable window").size.should == 1
    end
  end

  describe "#window" do
    it "finds window by :url" do
      w = browser.window(:url => /closeable\.html/)
      w.should be_kind_of(Watir::Window)
    end

    it "finds window by :title" do
      w = browser.window(:title => "closeable window")
      w.should be_kind_of(Watir::Window)
    end

    it "it executes the given block in the window" do
      browser.window(:title => "closeable window") do
        link = browser.a(:id => "close")
        link.should exist
        link.click
      end

      browser.windows.size.should == 1
    end

  end
end

describe Watir::Window do
  before do
    url = "file://" + File.expand_path("html/window_switching.html", File.dirname(__FILE__))
    browser.goto url
    browser.a(:id => "open").click
  end

  after do
    browser.window(:title => "closeable window").close
  end

  describe "#close" do
    it "closes the window" do
      pending
    end
  end

  describe "#use" do
    it "switches to the window" do
      pending
    end
  end

  describe "#current?" do
    it "returns true if it is the current window" do
      browser.window(:title => browser.title).should be_current
    end

    it "returns false if it is not the current window" do
      browser.window(:title => "closeable window").should_not be_current
    end
  end

  describe "#title" do
    it "returns the title of the window" do
      titles = browser.windows.map { |e| e.title }
      titles.size.should == 2
      
      ["window switching", "closeable window"].each do |title|
        titles.should include(title)
      end
    end

    it "does not change the current window" do
      browser.title.should == "window switching"
      browser.windows.find { |w| w.title ==  "closeable window" }.should_not be_nil
      browser.title.should == "window switching"
    end
  end

  describe "#url" do
    it "returns the url of the window" do
      browser.windows.size.should == 2
      browser.windows.select { |w| w.url =~ /window_switching\.html/ }.size.should == 1
      browser.windows.select { |w| w.url =~ /closeable\.html$/ }.size.should == 1
    end

    it "does not change the current window" do
      browser.url.should =~ /window_switching\.html/
      browser.windows.find { |w| w.url =~ /closeable\.html/ }.should_not be_nil
      browser.url.should =~ /window_switching/
    end
  end
end