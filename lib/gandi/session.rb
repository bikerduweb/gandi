require 'gandi/response'

module Gandi
  OLD_METHODS = %w(
  domain.owner.set_dry_run
  hosting.iface.ip_attach
  hosting.iface.ip_detach
  hosting.ip.create
  hosting.ip.delete
  )
  VALID_METHODS = %w(
  catalog.list

  cert.change_dcv
  cert.count
  cert.create
  cert.delete
  cert.get_dcv_params
  cert.info
  cert.list
  cert.package.list
  cert.renew
  cert.resend_dcv
  cert.update

  contact.balance
  contact.can_associate
  contact.can_associate_domain
  contact.count
  contact.create
  contact.delete
  contact.info
  contact.list
  contact.release
  contact.update
  contact.reachability.resend

  datacenter.list

  domain.autorenew.activate
  domain.autorenew.deactivate
  domain.available
  domain.contacts.set
  domain.count
  domain.create
  domain.claims.accept
  domain.claims.check
  domain.claims.info
  domain.delete.accept
  domain.delete.available
  domain.delete.decline
  domain.delete.info
  domain.delete.proceed
  domain.dnssec.create
  domain.dnssec.delete
  domain.dnssec.list
  domain.eoi.count
  domain.eoi.create
  domain.eoi.delete
  domain.eoi.info
  domain.eoi.list
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
  domain.misc.ukrights
  domain.nameservers.set
  domain.owner.set
  domain.packmail.autorenew
  domain.packmail.create
  domain.packmail.delete
  domain.packmail.info
  domain.packmail.renew
  domain.packmail.update
  domain.release
  domain.renew
  domain.reseller.set
  domain.restore
  domain.smd.count
  domain.smd.create
  domain.smd.delete
  domain.smd.extract
  domain.smd.info
  domain.smd.list
  domain.status.lock
  domain.status.unlock
  domain.tld.list
  domain.tld.region
  domain.transferin.available
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
  domain.zone.record.update
  domain.zone.set
  domain.zone.update
  domain.zone.version.count
  domain.zone.version.delete
  domain.zone.version.list
  domain.zone.version.new
  domain.zone.version.set

  hosting.catalog.list
  hosting.catalog.price
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
  hosting.iface.list
  hosting.iface.update
  hosting.image.info
  hosting.image.list
  hosting.ip.count
  hosting.ip.info
  hosting.ip.list
  hosting.ip.update
  hosting.metric.available
  hosting.metric.query
  hosting.product.create
  hosting.product.delete
  hosting.product.renew
  hosting.product.update
  hosting.rating.list
  hosting.rproxy.probe.check_server
  hosting.rproxy.probe.disable
  hosting.rproxy.probe.enable
  hosting.rproxy.probe.test
  hosting.rproxy.probe.update
  hosting.rproxy.count
  hosting.rproxy.create
  hosting.rproxy.delete
  hosting.rproxy.info
  hosting.rproxy.list
  hosting.rproxy.update
  hosting.rproxy.server.count
  hosting.rproxy.server.create
  hosting.rproxy.server.delete
  hosting.rproxy.server.disable
  hosting.rproxy.server.enable
  hosting.rproxy.server.list
  hosting.rproxy.vhost.alter_zone
  hosting.rproxy.vhost.count
  hosting.rproxy.vhost.create
  hosting.rproxy.vhost.delete
  hosting.rproxy.vhost.get_dns_entries
  hosting.rproxy.vhost.list
  hosting.ssh.count
  hosting.ssh.create
  hosting.ssh.delete
  hosting.ssh.info
  hosting.ssh.list
  hosting.vlan.count
  hosting.vlan.create
  hosting.vlan.delete
  hosting.vlan.info
  hosting.vlan.list
  hosting.vlan.update
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

  notification.count
  notification.list
  notification.test
  notification.subscription.count
  notification.subscription.create
  notification.subscription.delete
  notification.subscription.list

  operation.cancel
  operation.count
  operation.info
  operation.list
  operation.relaunch

  paas.count
  paas.create
  paas.delete
  paas.info
  paas.list
  paas.renew
  paas.restart
  paas.snapshot.count
  paas.snapshot.info
  paas.snapshot.list
  paas.type.count
  paas.type.list
  paas.update
  paas.vhost.count
  paas.vhost.create
  paas.vhost.delete
  paas.vhost.get_dns_entries
  paas.vhost.info
  paas.vhost.list

  security.key.renew

  site.alter_zone
  site.count
  site.create
  site.delete
  site.edit
  site.get_dns_entries
  site.info
  site.key.create
  site.key.delete
  site.key.list
  site.key.update
  site.list
  site.package.list
  site.renew
  site.update

  version.info
  )

  class ProxyCall
    attr_accessor :server, :api_key, :chained

    def initialize(server, api_key)
      self.server = server
      self.api_key = api_key
      self.chained = []
      self
    end

    undef_method :clone

    def method_missing(method, *args)
      self.chained << method
      method_name = chained.join(".")
      if Gandi::VALID_METHODS.include?(method_name)
        begin
          res = self.server.call(method_name, api_key, *args)
        rescue XMLRPC::FaultException => e
          raise Gandi::FaultCode.parse(e.faultCode, e.faultString).exception
        end

        if res.is_a?(Array)
          res.collect! { |x| x.is_a?(Hash) ? Gandi::Response.new(x) : x }
        elsif res.is_a?(Hash)
          Gandi::Response.new(res)
        else
          res
        end
      else
        self
      end
    end
  end

  class Session
    attr_reader :api_key

    def initialize(api_key, options = {})
      endpoint = options.is_a?(Hash) ? (ENDPOINT[options[:env]] || ENDPOINT[:production]) : options

      @api_key  = api_key
      @server = XMLRPC::Client.new2(endpoint)
      # fix a bug in ruby 2.0, http://bugs.ruby-lang.org/issues/8182
      @server.http_header_extra = { "accept-encoding" => "identity" }
      @server
    end

    def list_methods
      server.call('system.listMethods')
    end

    def method_signature(name)
      server.call('system.methodSignature', name)
    end

    def method_help(name)
      server.call('system.methodHelp', name)
    end

    def method_missing(method, *args)
      ProxyCall.new(@server, self.api_key).send(method, *args)
    end
  end
end
