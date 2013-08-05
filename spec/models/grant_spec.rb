require 'spec_helper.rb'

describe Granted::Grant do
  before(:all) do
    @alfred     = User.create name: 'Alfred'
    @grienhild  = User.create name: 'Grienhild'
    @alfreds    = Document.create name: 'Alfreds', content: 'Secret'

    Granted::Grant.create! grantee: @alfred, subject: @alfreds, right: :write
  end

  it "lists Alfred's document as one of his writeable documents" do
    @alfred.writeable_documents.count.should == 1
  end

  it "grant read access on Alfred's document to Grienhild" do
    expect{
      @grienhild.grant(:read).on(@alfreds)
    }.to change(@grienhild.readable_documents, :count).from(0).to(1)
  end

  it "revoke write access on Alfred's document from Alfred" do
    expect{
      @alfred.revoke(:write).on(@alfreds)
    }.to change(@alfred.writeable_documents, :count).from(1).to(0)
  end
end
