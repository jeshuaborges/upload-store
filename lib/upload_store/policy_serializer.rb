module UploadStore
  class PolicySerializer
    attr_reader :policy

    def initialize(policy)
      @policy = policy
    end

    def to_hash
      required_keys.merge(policy_keys)
    end

    private

    def required_keys
      {
        'upload-policy-provider'    => provider,
        'upload-policy-url'         => policy.url,
        'upload-policy-field-path'  => policy.path
      }
    end

    def policy_keys
      Hash[policy.fields.map{|k,v| ["upload-policy-field-#{k}", v] }]
    end

    def provider
      policy.class.name.split(/::/).last
    end
  end
end
