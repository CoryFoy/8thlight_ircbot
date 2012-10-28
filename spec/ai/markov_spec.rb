require_relative '../spec_helper'
require_relative '../../lib/irc/ai/markov'

describe IRC::AI::Markov do
  it "writes one word" do
    ai = IRC::AI::Markov.new
    ai.write("a")
    ai.store["a"].should == {}
  end

  it "writes two words" do
    ai = IRC::AI::Markov.new
    ai.write("a b")
    ai.store["a b"].should == {}
  end

  it "writes three words" do
    ai = IRC::AI::Markov.new
    ai.write("a b c")
    ai.store["a b"].keys.should == ["c"]
  end

  it "writes four words" do
    ai = IRC::AI::Markov.new
    ai.write("a b c d")
    ai.store["a b"].keys.should == ["c"]
    ai.store["b c"].keys.should == ["d"]
  end

  it "writes five duplicate words" do
    ai = IRC::AI::Markov.new
    ai.write("a a a a")
    ai.store["a a"].keys.should == ["a"]
  end

  it "writes word in lowercase" do
    ai = IRC::AI::Markov.new
    ai.write("A b c")
    ai.store["a b"].keys.should == ["c"]
  end

  it "reads one word" do
    ai = IRC::AI::Markov.new
    ai.write("a b c")
    ai.read("a b").should == "A b c."
  end

  it "reads more frequent words" do
    ai = IRC::AI::Markov.new
    ai.write("a b c")
    ai.write("a b c")
    ai.write("a b d")
    ai.read("a b").should == "A b c."
  end

  it "reads two words" do
    ai = IRC::AI::Markov.new
    ai.write("a b c")
    ai.write("b c d")
    ai.read("a b").should == "A b c d."
  end

  it "reads a sentence" do
    ai = IRC::AI::Markov.new
    ai.write("I have a book")
    ai.write("a book about Alchemy")
    ai.read("i have").should == "I have a book about Alchemy."
  end

  it "avoids a loop" do
    ai = IRC::AI::Markov.new
    ai.write("How much wood would a woodchuck chuck if a woodchuck could chuck wood?")
    ai.read("woodchuck chuck").should == "Woodchuck chuck if a woodchuck chuck."
  end
end
