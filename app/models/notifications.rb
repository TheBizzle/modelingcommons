class Notifications < ActionMailer::Base

  ActionMailer::Base.smtp_settings = {
    :address => "mail.modelingcommons.org",
    :port => 25,
    :domain => "modelingcommons.org",
    :authentication => :plain,
    :enable_starttls_auto => false
  }

  def signup(person)
    @recipients = person.email_address
    @bcc = 'reuven@lerner.co.il'
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject = "Welcome to the NetLogo Modeling Commons!"
    @body[:person] = person
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def reset_password(person)
    @recipients = person.email_address
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @body[:person] = person
    @subject    = 'Your new password'
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def password_reminder(person)
    @recipients = person.email_address
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @body[:person] = person
    @subject    = 'Your password'
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def changed_password(person)
    @recipients = person.email_address
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @body[:person] = person
    @subject    = 'Your new password'
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def modified_model(people, node)
    @recipients = node.people
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = 'Model update'
    @body[:nlmodel] = node
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def applied_tag(people, tag)
    @recipients = people.map{|p| p.email_address}
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = 'Tag was applied'
    @body[:tag] = tag
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def updated_discussion(people, nlmodel)
    @recipients = people.map{|p| p.email_address}
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = 'Updated discussion'
    @body[:nlmodel] = nlmodel
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def invited_to_group(person, membership)
    @recipients = person.email_address
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = 'Group invitation from the NetLogo Modeling Commons'
    @body[:membership] = membership
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def friend_recommendation(sender, friend_email_address, node)
    @recipients = friend_email_address
    @cc = sender.email_address
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = 'View an interesting NetLogo model'
    @body[:node] = node
    @body[:sender] = sender
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

  def recommended_message(recommender, people, model)
    @recipients = recommender.email_address
    @bcc = people.map{|p| p.email_address}
    @from = "nlcommons@monk.ccl.northwestern.edu"
    @subject    = "Recommendation for the '#{model.name}' model in the NetLogo Modeling Commons"
    @body[:nlmodel] = model
    @body[:recommender] = recommender
    @sent_on    = Time.now()
    @content_type = 'text/html'
  end

end
