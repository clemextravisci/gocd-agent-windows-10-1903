echo "Begin execution"

$AGENT_AUTOREGISTER_PROPERTIES='c:\GoAgent\config\autoregister.properties'
# $AGENT_AUTOREGISTER_PROPERTIES='autoregister.properties'

function setup_autoregister_properties_file_for_elastic_agent {

@"
agent.auto.register.key=$Env:GO_EA_AUTO_REGISTER_KEY
agent.auto.register.environments=$Env:GO_EA_AUTO_REGISTER_ENVIRONMENT
agent.auto.register.elasticAgent.agentId=$Env:GO_EA_AUTO_REGISTER_ELASTIC_AGENT_ID
agent.auto.register.elasticAgent.pluginId=$Env:GO_EA_AUTO_REGISTER_ELASTIC_PLUGIN_ID
agent.auto.register.hostname=$Env:AGENT_AUTO_REGISTER_HOSTNAME
"@ | Set-Content "$AGENT_AUTOREGISTER_PROPERTIES"

  [Environment]::SetEnvironmentVariable('GO_SERVER_URL', $Env:GO_EA_SERVER_URL, 'Machine')

  # unset variables, so we don't pollute and leak sensitive stuff to the agent process...
  [Environment]::SetEnvironmentVariable("GO_EA_AUTO_REGISTER_KEY",$null,"Machine")
  [Environment]::SetEnvironmentVariable("GO_EA_AUTO_REGISTER_ENVIRONMENT",$null,"Machine")
  [Environment]::SetEnvironmentVariable("GO_EA_AUTO_REGISTER_ELASTIC_AGENT_ID",$null,"Machine")
  [Environment]::SetEnvironmentVariable("GO_EA_AUTO_REGISTER_ELASTIC_PLUGIN_ID",$null,"Machine")
  [Environment]::SetEnvironmentVariable("GO_EA_SERVER_URL",$null,"Machine")
  [Environment]::SetEnvironmentVariable("AGENT_AUTO_REGISTER_HOSTNAME",$null,"Machine")

}

function setup_autoregister_properties_file_for_normal_agent {

@"
agent.auto.register.key=$Env:AGENT_AUTO_REGISTER_KEY
agent.auto.register.resources=$Env:AGENT_AUTO_REGISTER_RESOURCES
agent.auto.register.environments=$Env:AGENT_AUTO_REGISTER_ENVIRONMENTS
agent.auto.register.hostname=$Env:AGENT_AUTO_REGISTER_HOSTNAME
"@ | Set-Content "$AGENT_AUTOREGISTER_PROPERTIES"

  # unset variables, so we don't pollute and leak sensitive stuff to the agent process...

  [Environment]::SetEnvironmentVariable("AGENT_AUTO_REGISTER_KEY",$null,"Machine")
  [Environment]::SetEnvironmentVariable("AGENT_AUTO_REGISTER_RESOURCES",$null,"Machine")
  [Environment]::SetEnvironmentVariable("AGENT_AUTO_REGISTER_ENVIRONMENTS",$null,"Machine")
  [Environment]::SetEnvironmentVariable("AGENT_AUTO_REGISTER_HOSTNAME",$null,"Machine")

}

function setup_autoregister_properties_file {
  echo "setup auto register"
  if(Test-Path env:GO_EA_SERVER_URL) {
    setup_autoregister_properties_file_for_elastic_agent
  } else {
    setup_autoregister_properties_file_for_normal_agent
  }
}

setup_autoregister_properties_file

echo "Start Go agent server"
echo "GO server url $Env:GO_SERVER_URL"

echo "autoregister file content:"
cat $AGENT_AUTOREGISTER_PROPERTIES

Start-Service -Name "Go*" ;

(Get-Service -Name "Go*").WaitForStatus('Running') ;

Get-Service -Name "Go*"

(Get-Service -Name "Go*").WaitForStatus('Stopped') ;
