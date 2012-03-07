module Gandi
  VALID_METHODS = %w(
  catalog.list
  contact.balance
  contact.can_associate
  contact.can_associate_domain
  contact.create
  contact.info
  contact.list
  contact.update
  datacenter.list
  domain.available
  domain.contacts.set
  domain.count
  domain.create
  domain.forward.count
  domain.forward.create
  domain.forward.delete
  domain.forward.list
  domain.forward.update
  domain.host.count
  domain.host.create
  domain.host.delete
  domain.host.info
  domain.host.list
  domain.host.update
  domain.info
  domain.list
  domain.mailbox.alias.set
  domain.mailbox.count
  domain.mailbox.create
  domain.mailbox.delete
  domain.mailbox.info
  domain.mailbox.list
  domain.mailbox.purge
  domain.mailbox.responder.activate
  domain.mailbox.responder.deactivate
  domain.mailbox.update
  domain.nameservers.set
  domain.packmail.autorenew
  domain.packmail.create
  domain.packmail.delete
  domain.packmail.info
  domain.packmail.renew
  domain.packmail.update
  domain.renew
  domain.status.lock
  domain.status.unlock
  domain.tld.list
  domain.tld.region
  domain.transferin.proceed
  domain.webredir.count
  domain.webredir.create
  domain.webredir.delete
  domain.webredir.list
  domain.webredir.update
  domain.zone.clone
  domain.zone.count
  domain.zone.create
  domain.zone.delete
  domain.zone.info
  domain.zone.list
  domain.zone.record.add
  domain.zone.record.count
  domain.zone.record.delete
  domain.zone.record.list
  domain.zone.record.set
  domain.zone.set
  domain.zone.update
  domain.zone.version.delete
  domain.zone.version.new
  domain.zone.version.set
  hosting.datacenter.list
  hosting.disk.count
  hosting.disk.create
  hosting.disk.create_from
  hosting.disk.delete
  hosting.disk.info
  hosting.disk.list
  hosting.disk.list_kernels
  hosting.disk.list_options
  hosting.disk.rollback_from
  hosting.disk.update
  hosting.iface.count
  hosting.iface.create
  hosting.iface.delete
  hosting.iface.info
  hosting.iface.ip_attach
  hosting.iface.ip_detach
  hosting.iface.list
  hosting.iface.update
  hosting.image.info
  hosting.image.list
  hosting.ip.count
  hosting.ip.create
  hosting.ip.delete
  hosting.ip.info
  hosting.ip.list
  hosting.ip.update
  hosting.vm.count
  hosting.vm.create
  hosting.vm.create_from
  hosting.vm.delete
  hosting.vm.disk_attach
  hosting.vm.disk_detach
  hosting.vm.disk_rollback
  hosting.vm.iface_attach
  hosting.vm.iface_detach
  hosting.vm.info
  hosting.vm.list
  hosting.vm.reboot
  hosting.vm.start
  hosting.vm.stop
  hosting.vm.update
  operation.count
  operation.info
  operation.list
  )

  class ProxyCall
    attr_accessor :server, :api_key, :chained

    def initialize(server, api_key)
      self.server = server
      self.api_key = api_key
      self.chained = []
      self
    end

    def method_missing(method, *args)
      self.chained << method
      method_name = chained.join(".")
      if Gandi::VALID_METHODS.include?(method_name)
        # puts "CALL: #{method_name} - #{api_key} - #{args.inspect}"
        self.server.call(method_name, api_key, *args)
      else
        self
      end
    end
  end

  class Session
    attr_reader :api_key

    def initialize(api_key, endpoint = "https://rpc.gandi.net/xmlrpc/")
      @api_key  = api_key
      @server = XMLRPC::Client.new2(endpoint)
    end

    def method_missing(method, *args)
      ProxyCall.new(@server, self.api_key).send(method, *args)
    rescue XMLRPC::FaultException => exception
      raise(exception.faultCode < 500000 ? Gandi::ServerError : Gandi::DataError, exception.faultString)
    end
  end
end