Before('@twitter') do
  FakeWeb.allow_net_connect = false  
end
After('@twitter') do
  FakeWeb.allow_net_connect = true  
end