module("luci.controller.subconverter", package.seeall)

function index()
	entry({"admin", "services", "subconverter"}, cbi("subconverter/index"), _("Subconverter Web"), 1)
	entry({"admin", "services", "subconverter","restart"},call("restart_service"))
	entry({"admin", "services", "subconverter","getconfig"},call("get_config"))
end

function restart_service()
	luci.sys.call("/etc/init.d/subconverter stop")
	luci.sys.call("/etc/init.d/subconverter start")
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		code=200
	})
end

function get_config()
	local uci = require("luci.model.uci").cursor()
	local subscribeAddress = uci:get("subconverter", "config", "subscribeAddress") or ""
	local client = uci:get("subconverter", "config", "client") or ""
	if client == "" then
		client = "clash"
	end
	local remoteConfig = uci:get("subconverter", "config", "remoteConfig") or ""
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		subscribeAddress=subscribeAddress,
		client=client,
		remoteConfig=remoteConfig
	})
end