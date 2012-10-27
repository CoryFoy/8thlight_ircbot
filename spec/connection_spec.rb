require 'spec_helper'
require_relative '../lib/irc/connection'

describe IRC::Connection do
  context "start" do
    it "quits when server responds with nothing" do
      mock_socket = mock("socket", :gets => nil)
      mock_client = mock("client", :socket => mock_socket)
      mock_stdin = mock("$stdin")

      IRC::Connection.should_receive(:select).with([mock_socket, mock_stdin]).and_return([[mock_socket]])

      IRC::Connection.start(mock_client, mock_stdin)
    end

    it "quits when server responds with nothing" do
      mock_socket = mock("socket")
      mock_socket.should_receive(:gets).and_return('PRIVMSG ME')
      mock_socket.should_receive(:gets).and_return(nil)
      mock_client = mock("client", :socket => mock_socket)
      mock_stdin = mock("$stdin")
      mock_bot = mock("bot")
      mock_bot.should_receive(:respond).with('PRIVMSG ME')

      IRC::Connection.should_receive(:select).with([mock_socket, mock_stdin]).and_return([[mock_socket]])
      IRC::Bot.should_receive(:new).with(mock_client).and_return(mock_bot)
      IRC::Connection.should_receive(:select).with([mock_socket, mock_stdin]).and_return([[mock_socket]])

      IRC::Connection.start(mock_client, mock_stdin)
    end
  end
end
