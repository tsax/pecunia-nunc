require "spec_helper"

describe ReportingMailer do
  describe "project_errors_email" do
    let(:mail) { ReportingMailer.project_errors_email }

    it "renders the headers" do
      mail.subject.should eq("Project errors email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
