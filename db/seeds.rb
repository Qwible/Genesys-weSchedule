
# frozen_string_literal: true

################################################################
#                           Users                              #
################################################################
# admin 1
user = User.new
user.email = 'admin1@gmail.com'
user.password = 'password'
user.password_confirmation = 'password'
user.account_type = AccountType::ADMIN
user.save

# Standard user
free_user = User.new
free_user.email = 'standard@gmail.com'
free_user.password = 'password'
free_user.password_confirmation = 'password'
free_user.account_type = AccountType::FREE
free_user.save

# Premium user
premium_user = User.new
premium_user.email = 'premium@gmail.com'
premium_user.password = 'password'
premium_user.password_confirmation = 'password'
premium_user.account_type = AccountType::PREMIUM
premium_user.save

################################################################
#                           Tasks                              #
################################################################

# Instantiate tasks for the premium user

task = Task.new
task.name = "COM4525: Genesys - Assignment"
task.length = 20
task.schedule = true
task.priority = 1
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 7.days
task.user_id = premium_user.id
task.save

task = Task.new
task.name = "COM4521: GPU - Assignment"
task.length = 15
task.schedule = true
task.priority = 1
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 10.days
task.user_id = premium_user.id
task.save

task = Task.new
task.name = "COM4513: NLP - Assignment 2"
task.length = 5
task.schedule = true
task.priority = 2
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 7.days
task.user_id = premium_user.id
task.save

# Instantiate tasks for the free user

task = Task.new
task.name = "COM4525: Genesys - Assignment"
task.length = 20
task.schedule = true
task.priority = 1
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 7.days
task.user_id = free_user.id
task.save

task = Task.new
task.name = "COM4521: GPU - Assignment"
task.length = 15
task.schedule = true
task.priority = 1
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 10.days
task.user_id = free_user.id
task.save

task = Task.new
task.name = "COM4513: NLP -  Assignment 2"
task.length = 5
task.schedule = true
task.priority = 2
# Since this is time sensitive its really difficult to seed,
# I'll assume database seeding will happen shortly before marking
task.end_datetime = Time.now + 7.days
task.user_id = free_user.id
task.save

################################################################
#                          Reviews                             #
################################################################

review = Review.new
review.anonymous = true
review.first_name = "Jane"
review.last_name = "Doe"
review.review = "This app has really helped me organise my studying time!"
review.save

review = Review.new
review.anonymous = false
review.first_name = "John"
review.last_name = "Doe"
review.review = "10/10 would reccomend this app"
review.pinned = true
review.save

################################################################
#                          FAQ                                #
################################################################

faq = Question.new
faq.date = Date.new
faq.text = "If the universe is so big, why won't it fight me?"
faq.save

################################################################
#                          Feedback                            #
################################################################

feedback = Feedback.new
feedback.feedback_category = 'Positive'
feedback.comment = "Very nice app"
feedback.save

feedback = Feedback.new
feedback.feedback_category = 'Neutral'
feedback.comment = "App is okay"
feedback.save

feedback = Feedback.new
feedback.feedback_category = 'Negative'
feedback.comment = "App is absolute garbage"
feedback.save
