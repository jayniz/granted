require 'spec_helper.rb'

describe Granted::Grant do
  before(:all) do
    @alfred  = User.create name: 'Alfred'
    @bruce   = User.create name: 'Bruce'
    @alfreds = Document.create name: 'Alfreds', content: 'Secret'
    @bruces  = Document.create name: 'Bruces', content: 'Secret'

    Granted::WriteGrant.create! grantee: @alfred, subject: @alfreds
  end

  context "using a grantee as the starting point" do
    it "lists Alfred's document as one of his writeable documents" do
      @alfred.writeable_documents.count.should == 1
    end

    it "Alfred has no readable documents" do
      @alfred.readable_documents.count.should == 0
    end

    it "Bruce has no documents at all" do
      @bruce.all_documents.count.should == 0
    end

    it "grant read access on Alfred's document to Bruce" do
      Granted::Grant.destroy_all
      expect{
        @bruce.grant(:read).on(@alfreds)
      }.to change(@bruce.readable_documents, :count).from(0).to(1)
    end

    it "grant all access on Alfred's document to Bruce" do
      Granted::Grant.destroy_all
      expect{
        @bruce.grant(:read, :write, :destroy).on(@alfreds)
      }.to change(Grant, :count).from(0).to(3)
    end

    it "revoke write access on Alfred's document from Alfred" do
      expect{
        @alfred.revoke(:write).on(@alfreds)
      }.to change(@alfred.writeable_documents, :count).from(1).to(0)
    end

    it "returns Alfred only once even though he has multiple rights" do
      Granted::DestroyGrant.create(subject: @alfreds, grantee: @alfred)
      @alfred.grants.count.should == 2
      @alfred.all_documents.count.should == 1
    end
  end

  context "using a subject as the starting point" do
    it "lists Alfred's document as one of his writeable documents" do
      @alfreds.write_users.count.should == 1
    end

    it "grant read access on Alfred's document to Bruce" do
      Granted::Grant.destroy_all
      expect{
        @alfreds.grant(:read).to(@bruce)
      }.to change(@alfreds.read_users, :count).from(0).to(1)
    end

    it "grant all access on Alfred's document to Bruce" do
      Granted::Grant.destroy_all
      expect{
        @alfreds.grant(:read, :write, :destroy).to(@bruce)
      }.to change(Grant, :count).from(0).to(3)
    end

    it "revoke write access on Alfred's document from Alfred" do
      expect{
        @alfreds.revoke(:write).from(@alfred)
      }.to change(@alfreds.write_users, :count).from(1).to(0)
    end

    it "returns Alfreds only once even though he has multiple rights" do
      Granted::DestroyGrant.create(subject: @alfreds, grantee: @alfred)
      @alfreds.grants.count.should == 2
      @alfreds.all_users.count.should == 1
    end
  end

  context "granting/revoking rights: rails association style" do
    it "adds a grant via subject's <<" do
      expect{
        @bruces.read_users << @alfred
        @bruces.save!
      }.to change(@alfred.readable_documents, :count).from(0).to(1)
    end

    it "adds a grant via grantee's <<" do
      expect{
        @alfred.readable_documents << @bruces
        @alfred.save!
      }.to change(@bruces.read_users, :count).by(1)
    end
  end

  context "removing grant objects" do
   it "when subject is deleted" do
     expect{
       @alfreds.destroy
     }.to change(Grant, :count).by(-1)
   end

   it "when grantee is deleted" do
    expect{
      @alfred.destroy
    }.to change(Grant, :count).by(-1)
   end
  end
end
