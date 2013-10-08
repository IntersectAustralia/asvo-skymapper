# Be sure to restart your server when you modify this file.

ASVO_REGISTRY_FILEPATH = Rails.root.join('config/asvo_registry.yml')

AsvoSkymapper::Application.config.asvo_registry = Registry.new(ASVO_REGISTRY_FILEPATH)
