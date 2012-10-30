require_relative '../spec_helper'
require_relative '../../lib/irc/ai/markov'

describe IRC::AI::Markov do
  before do
    IO.stub(:read).and_return('a')
  end

  it "writes one word" do
    ai = IRC::AI::Markov.new
    ai.write("one")
    ai.store["one"].should == {}
  end

  it "writes two words" do
    ai = IRC::AI::Markov.new
    ai.write("one two")
    ai.store["one two"].should == {}
  end

  it "writes three words" do
    ai = IRC::AI::Markov.new
    ai.write("one two three")
    ai.store["one"].keys.should == ["two"]
    ai.store["two"].keys.should == ["three"]
  end

  it "writes five duplicate words" do
    ai = IRC::AI::Markov.new
    ai.write("cat cat cat cat cat")
    ai.store["cat"].values.first.frequency.should == 4
  end

  it "writes five duplicate stop words" do
    ai = IRC::AI::Markov.new
    ai.write("a a a a")
    ai.store["a"].values.first.frequency.should == 0
  end

  it "writes word in lowercase" do
    ai = IRC::AI::Markov.new
    ai.write("One two")
    ai.store["one"].keys.should == ["two"]
  end

  it "reads one word" do
    ai = IRC::AI::Markov.new
    ai.write("One two three")
    ai.read("one").should == "One two three."
  end

  it "reads more frequent words" do
    ai = IRC::AI::Markov.new
    ai.write("one two three")
    ai.write("one two three")
    ai.write("one two four")
    ai.read("one").should == "One two three."
  end

  it "reads two words" do
    ai = IRC::AI::Markov.new
    ai.write("one two three")
    ai.write("two three four")
    ai.read("one").should == "One two three four."
  end

  it "reads a sentence" do
    ai = IRC::AI::Markov.new
    ai.write("I have a book")
    ai.write("a book about Alchemy")
    ai.read("I").should == "I have a book about Alchemy."
  end

  it "avoids a loop" do
    ai = IRC::AI::Markov.new
    ai.write("one two one")
    ai.read("one").should == "One two one."
  end

  it "resets visit" do
    ai = IRC::AI::Markov.new
    ai.write("a a a")
    ai.read("a a")
    ai.store["a"]["a"].visit.should be_false
  end

  it "recognizes sentences" do
    ai = IRC::AI::Markov.new
    ai.write("one two three. one two three! one two four?")
    ai.read("one").should == "One two three."
  end
end
