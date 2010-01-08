require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Diffaroo::ModifyDelta do
  describe ".new" do
    it "takes two arguments" do
      proc { Diffaroo::ModifyDelta.new(:foo)             }.should     raise_error(ArgumentError)
      proc { Diffaroo::ModifyDelta.new(:foo, :bar)       }.should_not raise_error(ArgumentError)
      proc { Diffaroo::ModifyDelta.new(:foo, :bar, :quux)}.should     raise_error(ArgumentError)
    end
  end

  describe "#node1" do
    it "returns the first initializer parameter" do
      Diffaroo::ModifyDelta.new(:foo, :bar).node1.should == :foo
    end
  end

  describe "#node2" do
    it "returns the first initializer parameter" do
      Diffaroo::ModifyDelta.new(:foo, :bar).node2.should == :bar
    end
  end

  describe "#apply!" do
    context "element nod" do
      context "when attributes differ" do
        it "should set the attributes properly" do
          doc1 = xml { root { a1(:foo => :bar) } }
          doc2 = xml { root { a1(:bazz => :quux, :once => :twice) } }
          doc3 = doc1.dup
          node1 = doc1.at_css("a1")
          node2 = doc2.at_css("a1")
          node3 = doc3.at_css("a1")

          delta = Diffaroo::ModifyDelta.new(node1, node2)
          delta.apply!(doc3)
          
          node3["foo"].should be_nil
          node3["bazz"].should == "quux"
          node3["once"].should == "twice"
        end
      end

      context "when positions differ" do
        it "should do something"
      end
    end

    context "text node" do
      it "should set the content properly" do
        doc1 = xml { root "hello" }
        doc2 = xml { root "goodbye" }
        doc3 = doc1.dup

        delta = Diffaroo::ModifyDelta.new(doc1.root.children.first, doc2.root.children.first)
        delta.apply!(doc3)

        doc3.root.content.should == "goodbye"
      end
    end
  end
end