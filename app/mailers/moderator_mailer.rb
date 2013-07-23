class ModeratorMailer < ActionMailer::Base
  default from: ISO[:from_email], to: ISO[:from_email]

  def report(report_id)
    @report = Report.find(report_id)

    mail(
      subject: "[Report] [From: #{@report.user.id}] #{@report.reportable.class_name} ##{@report.reportable_id}",
      body: @report.reason
    )
  end
end
