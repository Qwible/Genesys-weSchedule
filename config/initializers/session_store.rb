# frozen_string_literal: true

Rails.application.config.session_store :active_record_store, key: (if Rails.env.production?
                                                                     '_genesys_project_session_id'
                                                                   else
                                                                     (Rails.env.demo? ? '_genesys_project_demo_session_id' : '_genesys_project_dev_session_id')
                                                                   end),
                                                             secure: (Rails.env.demo? || Rails.env.production?),
                                                             httponly: true
