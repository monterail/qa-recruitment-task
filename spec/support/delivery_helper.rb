module DeliveryHelper
  def deliver_emails(changed_by)
    change { ActionMailer::Base.deliveries.count }.by(changed_by)
  end
end
