require 'spec_helper'

describe UserMailer do

  describe ".notify_service_request_status_change" do

    let!(:service_request) { FactoryGirl.create(:service_request) }
    let!(:status) { FactoryGirl.create(:status) }
    let!(:mail) { UserMailer.notify_service_request_status_change(service_request.id, status.id) }


    it "sends the email" do
      reset_email
      mail.deliver!
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "sends an email to the requester" do
      expect(mail.to).to eq( [service_request.requester.email] )
    end

    it "has a translated subject" do
      expect( mail.subject ).to eq(I18n.t('mailer.subject.status_change_notification'))
    end
  end

end

