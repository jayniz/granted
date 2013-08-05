require 'spec_helper.rb'

describe Granted::Grant do
  let(:alfred){     User.create name: 'Alfred'                          }
  let(:grienhild){  User.create name: 'Grienhild'                       }
  let(:alfreds){    Document.create name: 'Alfreds', content: 'Secret' }
  let(:grienhilds){ Document.create name: 'Alfreds', content: 'Secret' }
  let(:shared){     Document.create name: 'Alfreds', content: 'Secret' }

  it "makes Alfred owner of his first document" do
    expect{
      Granted::Grant.create! grantee: alfred, subject: alfreds, right: :write
    }.to change(Granted::Grant, :count).by(1)
  end

  it "lists Alfred's document as one of his writeable documents" do
    debugger
    alfred.writeable_documents.count.should == 1
  end

  xit "lets Alfred grant read to Grienhild" do

  end
end
