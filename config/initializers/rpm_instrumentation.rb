require 'new_relic/agent/method_tracer'

Account::PhotographsController.class_eval do
  include ::NewRelic::Agent::MethodTracer

  add_method_tracer :create
  add_method_tracer :update
end
